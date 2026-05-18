import { Text, View } from "react-native";

import { RecipeCard, SectionTitle } from "@/components/Cards";
import { Screen } from "@/components/Screen";
import { usePantry } from "@/context/PantryContext";
import { recipes } from "@/data/catalog";
import { colors, radius } from "@/data/theme";

export default function RecipesScreen() {
  const { pantry } = usePantry();
  const pantryIds = pantry.map((item) => item.ingredientId);

  return (
    <Screen contentStyle={{ paddingBottom: 104 }}>
      <View style={{ gap: 6 }}>
        <Text selectable style={{ color: colors.green, fontSize: 32, fontWeight: "900" }}>
          Recipes
        </Text>
        <Text selectable style={{ color: colors.muted, fontSize: 14, lineHeight: 21 }}>
          Matches are ranked by what you already have, then by how quickly they reduce leftovers.
        </Text>
      </View>

      <View
        style={{
          borderRadius: radius.lg,
          borderCurve: "continuous",
          backgroundColor: colors.red,
          padding: 18,
          gap: 6
        }}
      >
        <Text selectable style={{ color: colors.cream, fontSize: 18, fontWeight: "900" }}>
          Pantry match engine
        </Text>
        <Text selectable style={{ color: "rgba(255,220,157,0.78)", fontSize: 13, lineHeight: 20 }}>
          {pantry.length} ingredients available. Recipes with fewer missing items rise to the top.
        </Text>
      </View>

      <SectionTitle title="Recommended now" />
      <View style={{ flexDirection: "row", flexWrap: "wrap", gap: 12 }}>
        {recipes
          .map((recipe) => ({
            recipe,
            score: recipe.ingredients.filter((id) => pantryIds.includes(id)).length
          }))
          .sort((a, b) => b.score - a.score)
          .map(({ recipe }) => (
            <RecipeCard key={recipe.id} recipe={recipe} />
          ))}
      </View>
    </Screen>
  );
}
