import { Text, View } from "react-native";

import { colors, shadow } from "@/data/theme";
import type { Ingredient, Recipe } from "@/types/app";

export function IngredientGlyph({ ingredient, size = 54 }: { ingredient: Ingredient; size?: number }) {
  return (
    <View
      style={{
        width: size,
        height: size,
        borderRadius: size / 2,
        backgroundColor: ingredient.color,
        borderWidth: 1,
        borderColor: "rgba(53,22,9,0.08)",
        alignItems: "center",
        justifyContent: "center"
      }}
    >
      <View
        style={{
          width: size * 0.46,
          height: size * 0.46,
          borderRadius: size * 0.2,
          borderCurve: "continuous",
          backgroundColor: ingredient.accent,
          opacity: 0.92,
          transform: [{ rotate: ingredient.category === "produce" ? "-14deg" : "8deg" }]
        }}
      />
    </View>
  );
}

export function RecipeVisual({ recipe, compact = false }: { recipe: Recipe; compact?: boolean }) {
  return (
    <View
      style={{
        height: compact ? 86 : 170,
        borderRadius: compact ? 18 : 28,
        borderCurve: "continuous",
        backgroundColor: recipe.heroColor,
        overflow: "hidden",
        padding: compact ? 12 : 18,
        justifyContent: "flex-end",
        ...shadow
      }}
    >
      <View
        style={{
          position: "absolute",
          top: compact ? -20 : -32,
          right: compact ? -18 : -28,
          width: compact ? 92 : 170,
          height: compact ? 92 : 170,
          borderRadius: 100,
          backgroundColor: recipe.accentColor,
          opacity: 0.86
        }}
      />
      <View
        style={{
          position: "absolute",
          bottom: compact ? -10 : -18,
          left: compact ? -10 : -16,
          width: compact ? 72 : 132,
          height: compact ? 72 : 132,
          borderRadius: 100,
          backgroundColor: colors.cream,
          opacity: 0.38
        }}
      />
      <Text selectable style={{ color: colors.cream, fontSize: compact ? 13 : 18, fontWeight: "900" }}>
        {recipe.title}
      </Text>
      {!compact ? (
        <Text selectable style={{ color: "rgba(255,220,157,0.78)", fontSize: 12, marginTop: 4 }}>
          {recipe.subtitle}
        </Text>
      ) : null}
    </View>
  );
}
