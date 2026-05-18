import { Link, useRouter } from "expo-router";
import { Pressable, Text, View } from "react-native";

import { AppButton } from "@/components/AppButton";
import { MetricPill, PantryRow, RecipeCard, SectionTitle } from "@/components/Cards";
import { Screen } from "@/components/Screen";
import { usePantry } from "@/context/PantryContext";
import { recipes } from "@/data/catalog";
import { colors, radius, shadow } from "@/data/theme";

export default function HomeScreen() {
  const router = useRouter();
  const { pantry, changeQuantity } = usePantry();
  const pantryIds = pantry.map((item) => item.ingredientId);
  const recommended = recipes
    .map((recipe) => ({
      recipe,
      score: recipe.ingredients.filter((id) => pantryIds.includes(id)).length
    }))
    .sort((a, b) => b.score - a.score)
    .map((item) => item.recipe);

  return (
    <Screen contentStyle={{ paddingBottom: 104 }}>
      <View
        style={{
          backgroundColor: colors.red,
          marginHorizontal: -20,
          marginTop: -60,
          paddingTop: 74,
          paddingHorizontal: 22,
          paddingBottom: 22,
          borderBottomLeftRadius: 30,
          borderBottomRightRadius: 30,
          borderCurve: "continuous",
          gap: 4
        }}
      >
        <Text selectable style={{ color: colors.cream, fontSize: 24, fontWeight: "900" }}>
          Hello, Alvina
        </Text>
        <Text selectable style={{ color: "rgba(255,220,157,0.74)", fontSize: 13 }}>
          Let&apos;s rescue what is already in your kitchen.
        </Text>
      </View>

      <View style={{ flexDirection: "row", gap: 12 }}>
        <MetricPill label="ingredients ready" value={String(pantry.length)} />
        <MetricPill label="recipe matches" value={String(recommended.length)} />
      </View>

      <SectionTitle title="Choose your ingredients" />
      <View style={{ flexDirection: "row", gap: 12 }}>
        <ActionCard label="Add Ingredients" detail="Search pantry items" onPress={() => router.push("/add-ingredients")} />
        <ActionCard label="Scan Ingredients" detail="Simulate camera scan" onPress={() => router.push("/scan")} />
      </View>

      <SectionTitle title="My ingredients list" />
      <View style={{ gap: 8 }}>
        {pantry.map((item) => (
          <PantryRow
            key={item.ingredientId}
            item={item}
            onDecrease={() => changeQuantity(item.ingredientId, -1)}
            onIncrease={() => changeQuantity(item.ingredientId, 1)}
          />
        ))}
      </View>

      <AppButton label="Start Cook" onPress={() => router.push("/recipes")} />

      <SectionTitle
        title="Recipe for you"
        action={
          <Link href="/recipes" asChild>
            <Pressable>
              <Text selectable style={{ color: colors.green, fontSize: 12, fontWeight: "800" }}>
                Show more
              </Text>
            </Pressable>
          </Link>
        }
      />
      <View style={{ flexDirection: "row", flexWrap: "wrap", gap: 12 }}>
        {recommended.slice(0, 4).map((recipe) => (
          <RecipeCard key={recipe.id} recipe={recipe} />
        ))}
      </View>
    </Screen>
  );
}

function ActionCard({ label, detail, onPress }: { label: string; detail: string; onPress: () => void }) {
  return (
    <Pressable
      onPress={onPress}
      style={({ pressed }) => ({
        flex: 1,
        borderRadius: radius.lg,
        borderCurve: "continuous",
        backgroundColor: colors.red,
        padding: 18,
        gap: 10,
        minHeight: 122,
        justifyContent: "space-between",
        opacity: pressed ? 0.82 : 1,
        ...shadow
      })}
    >
      <View
        style={{
          width: 38,
          height: 38,
          borderRadius: 19,
          backgroundColor: "rgba(255,220,157,0.18)",
          alignItems: "center",
          justifyContent: "center"
        }}
      >
        <View style={{ width: 16, height: 16, borderRadius: 5, backgroundColor: colors.cream }} />
      </View>
      <View style={{ gap: 2 }}>
        <Text selectable style={{ color: colors.cream, fontSize: 14, fontWeight: "900" }}>
          {label}
        </Text>
        <Text selectable style={{ color: "rgba(255,220,157,0.75)", fontSize: 11, lineHeight: 16 }}>
          {detail}
        </Text>
      </View>
    </Pressable>
  );
}
