import { useLocalSearchParams, useRouter } from "expo-router";
import { Text, View } from "react-native";

import { AppButton } from "@/components/AppButton";
import { SectionTitle } from "@/components/Cards";
import { IngredientGlyph, RecipeVisual } from "@/components/FoodVisual";
import { Screen } from "@/components/Screen";
import { usePantry } from "@/context/PantryContext";
import { getIngredient, getRecipe } from "@/data/catalog";
import { colors, radius } from "@/data/theme";

export default function RecipeDetailScreen() {
  const router = useRouter();
  const { id } = useLocalSearchParams<{ id: string }>();
  const { hasIngredient, addIngredients } = usePantry();
  const recipe = getRecipe(id);

  if (!recipe) {
    return (
      <Screen>
        <Text selectable style={{ color: colors.red, fontSize: 24, fontWeight: "900" }}>
          Recipe not found
        </Text>
        <AppButton label="Back" onPress={() => router.back()} />
      </Screen>
    );
  }

  const missing = recipe.ingredients.filter((ingredientId) => !hasIngredient(ingredientId));

  return (
    <Screen contentStyle={{ paddingBottom: 34 }}>
      <AppButton label="Back" variant="ghost" onPress={() => router.back()} style={{ alignSelf: "flex-start", minHeight: 38 }} />
      <RecipeVisual recipe={recipe} />

      <View style={{ gap: 8 }}>
        <Text selectable style={{ color: colors.green, fontSize: 30, fontWeight: "900" }}>
          {recipe.title}
        </Text>
        <Text selectable style={{ color: colors.muted, fontSize: 14, lineHeight: 21 }}>
          {recipe.subtitle}
        </Text>
      </View>

      <View style={{ flexDirection: "row", gap: 10 }}>
        {[recipe.time, recipe.servings, recipe.difficulty].map((item) => (
          <View
            key={item}
            style={{
              flex: 1,
              borderRadius: radius.md,
              borderCurve: "continuous",
              backgroundColor: colors.paper,
              borderWidth: 1,
              borderColor: colors.line,
              padding: 12,
              alignItems: "center"
            }}
          >
            <Text selectable style={{ color: colors.red, fontSize: 12, fontWeight: "900", textAlign: "center" }}>
              {item}
            </Text>
          </View>
        ))}
      </View>

      <SectionTitle title="Ingredients" />
      <View style={{ gap: 8 }}>
        {recipe.ingredients.map((ingredientId) => {
          const ingredient = getIngredient(ingredientId);
          if (!ingredient) return null;
          const owned = hasIngredient(ingredientId);
          return (
            <View
              key={ingredientId}
              style={{
                flexDirection: "row",
                alignItems: "center",
                gap: 12,
                borderRadius: radius.md,
                borderCurve: "continuous",
                backgroundColor: owned ? "#EEF5DE" : colors.paper,
                padding: 12,
                borderWidth: 1,
                borderColor: owned ? "rgba(45,80,22,0.22)" : colors.line
              }}
            >
              <IngredientGlyph ingredient={ingredient} size={42} />
              <Text selectable style={{ flex: 1, color: colors.ink, fontWeight: "900" }}>
                {ingredient.name}
              </Text>
              <Text selectable style={{ color: owned ? colors.green : colors.red, fontSize: 12, fontWeight: "900" }}>
                {owned ? "Ready" : "Missing"}
              </Text>
            </View>
          );
        })}
      </View>

      {missing.length > 0 ? (
        <AppButton label="Add Missing Ingredients" variant="red" onPress={() => addIngredients(missing)} />
      ) : null}

      <View
        style={{
          borderRadius: radius.lg,
          borderCurve: "continuous",
          backgroundColor: colors.green,
          padding: 18,
          gap: 6
        }}
      >
        <Text selectable style={{ color: colors.cream, fontSize: 16, fontWeight: "900" }}>
          Waste-saving note
        </Text>
        <Text selectable style={{ color: "rgba(255,220,157,0.82)", fontSize: 13, lineHeight: 20 }}>
          {recipe.wasteNote}
        </Text>
      </View>

      <SectionTitle title="Cooking steps" />
      <View style={{ gap: 10 }}>
        {recipe.steps.map((step, index) => (
          <View
            key={step}
            style={{
              flexDirection: "row",
              gap: 12,
              borderRadius: radius.md,
              borderCurve: "continuous",
              backgroundColor: colors.paper,
              borderWidth: 1,
              borderColor: colors.line,
              padding: 14
            }}
          >
            <Text selectable style={{ color: colors.red, fontWeight: "900", width: 20 }}>
              {index + 1}
            </Text>
            <Text selectable style={{ flex: 1, color: colors.ink, lineHeight: 21 }}>
              {step}
            </Text>
          </View>
        ))}
      </View>
      <AppButton label="Cook This Recipe" onPress={() => router.replace("/history")} />
    </Screen>
  );
}
