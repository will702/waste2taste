# Deploying to Google Cloud Run

## Prerequisites

- GCP project created with billing enabled
- `gcloud` CLI installed and authenticated: `gcloud auth login`
- Cloud Run API enabled: `gcloud services enable run.googleapis.com`
- Container Registry API enabled: `gcloud services enable containerregistry.googleapis.com`
- Secret Manager API enabled: `gcloud services enable secretmanager.googleapis.com`

## Step 1: Configure project

```bash
export PROJECT_ID=your-gcp-project-id
export REGION=us-central1
export API_IMAGE=gcr.io/$PROJECT_ID/waste2taste-api
export ML_IMAGE=gcr.io/$PROJECT_ID/waste2taste-ml

gcloud config set project $PROJECT_ID
gcloud auth configure-docker
```

## Step 2: Build and push images

```bash
# From the backend/ directory
docker build -t $API_IMAGE ./api
docker push $API_IMAGE

docker build -t $ML_IMAGE ./ml
docker push $ML_IMAGE
```

## Step 3: Create secrets in Secret Manager

```bash
echo -n "https://your-project.supabase.co" | gcloud secrets create SUPABASE_URL --data-file=-
echo -n "your-anon-key"     | gcloud secrets create SUPABASE_ANON_KEY --data-file=-
echo -n "your-service-key"  | gcloud secrets create SUPABASE_SERVICE_ROLE_KEY --data-file=-
```

If secrets already exist, update them:
```bash
echo -n "value" | gcloud secrets versions add SECRET_NAME --data-file=-
```

## Step 4: Create GCP service account JSON secret (for Google Vision)

```bash
gcloud secrets create GCP_SERVICE_ACCOUNT \
  --data-file=/path/to/your-service-account.json
```

## Step 5: Deploy ML service (internal-only)

```bash
gcloud run deploy waste2taste-ml \
  --image $ML_IMAGE \
  --region $REGION \
  --no-allow-unauthenticated \
  --ingress internal \
  --memory 2Gi \
  --cpu 2 \
  --min-instances 0 \
  --max-instances 5 \
  --set-secrets "GOOGLE_APPLICATION_CREDENTIALS=GCP_SERVICE_ACCOUNT:latest"
```

Note the service URL in the output — you'll need it in the next step.

## Step 6: Deploy API service (public)

```bash
ML_URL=$(gcloud run services describe waste2taste-ml \
  --region $REGION \
  --format 'value(status.url)')

gcloud run deploy waste2taste-api \
  --image $API_IMAGE \
  --region $REGION \
  --allow-unauthenticated \
  --ingress all \
  --memory 512Mi \
  --cpu 1 \
  --min-instances 0 \
  --max-instances 10 \
  --set-secrets "SUPABASE_URL=SUPABASE_URL:latest,SUPABASE_ANON_KEY=SUPABASE_ANON_KEY:latest,SUPABASE_SERVICE_ROLE_KEY=SUPABASE_SERVICE_ROLE_KEY:latest" \
  --set-env-vars "ML_SERVICE_URL=$ML_URL"
```

## Step 7: Smoke test

```bash
API_URL=$(gcloud run services describe waste2taste-api \
  --region $REGION \
  --format 'value(status.url)')

# Health check
curl $API_URL/health
# Expected: {"status":"ok"}

# Register test user
curl -X POST $API_URL/auth/register \
  -H "Content-Type: application/json" \
  -d '{"email":"test@waste2taste.com","password":"testpass123"}'
```

## Updating deployments

After code changes, rebuild and push the image, then update the Cloud Run service:
```bash
docker build -t $API_IMAGE ./api && docker push $API_IMAGE
gcloud run deploy waste2taste-api --image $API_IMAGE --region $REGION
```

## Important notes

- The ML service uses `--ingress internal` — it is NOT reachable from the internet, only from the API service
- Cloud Run scales to zero when idle (no idle cost)
- The API service uses `--allow-unauthenticated` because the mobile app authenticates via Supabase JWT (not GCP IAM)
- Supabase migrations (`backend/supabase/migrations/`) must be run manually in the Supabase dashboard before deploying
