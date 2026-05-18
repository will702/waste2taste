import { Text, View } from "react-native";

import { MetricPill, SectionTitle } from "@/components/Cards";
import { RecipeVisual } from "@/components/FoodVisual";
import { Screen } from "@/components/Screen";
import { getRecipe, history } from "@/data/catalog";
import { colors, radius } from "@/data/theme";

export default function HistoryScreen() {
  return (
    <Screen contentStyle={{ paddingBottom: 104 }}>
      <View style={{ gap: 6 }}>
        <Text selectable style={{ color: colors.green, fontSize: 32, fontWeight: "900" }}>
          Cooking History
        </Text>
        <Text selectable style={{ color: colors.muted, fontSize: 14, lineHeight: 21 }}>
          Track what you cooked and what ingredients were saved from waste.
        </Text>
      </View>
      <View style={{ flexDirection: "row", gap: 12 }}>
        <MetricPill label="meals cooked" value="12" />
        <MetricPill label="items saved" value="18" />
      </View>
      <SectionTitle title="Recent meals" />
      <View style={{ gap: 12 }}>
        {history.map((entry) => {
          const recipe = getRecipe(entry.recipeId);
          if (!recipe) return null;
          return (
            <View
              key={entry.id}
              style={{
                borderRadius: radius.lg,
                borderCurve: "continuous",
                backgroundColor: colors.paper,
                padding: 12,
                gap: 10,
                borderWidth: 1,
                borderColor: colors.line
              }}
            >
              <RecipeVisual recipe={recipe} compact />
              <View style={{ flexDirection: "row", justifyContent: "space-between", gap: 12 }}>
                <View style={{ flex: 1 }}>
                  <Text selectable style={{ color: colors.ink, fontSize: 15, fontWeight: "900" }}>
                    {recipe.title}
                  </Text>
                  <Text selectable style={{ color: colors.muted, fontSize: 12 }}>
                    {entry.cookedAt}
                  </Text>
                </View>
                <Text selectable style={{ color: colors.green, fontSize: 12, fontWeight: "900" }}>
                  {entry.saved}
                </Text>
              </View>
            </View>
          );
        })}
      </View>
    </Screen>
  );
}
