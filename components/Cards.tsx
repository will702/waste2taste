import { Link } from "expo-router";
import type React from "react";
import { Pressable, Text, View } from "react-native";

import { IngredientGlyph, RecipeVisual } from "@/components/FoodVisual";
import { getIngredient } from "@/data/catalog";
import { colors, radius, shadow } from "@/data/theme";
import type { Ingredient, PantryItem, Recipe } from "@/types/app";

export function SectionTitle({ title, action }: { title: string; action?: React.ReactNode }) {
  return (
    <View style={{ flexDirection: "row", justifyContent: "space-between", alignItems: "center" }}>
      <Text selectable style={{ color: colors.red, fontSize: 15, fontWeight: "900" }}>
        {title}
      </Text>
      {action}
    </View>
  );
}

export function IngredientChip({
  ingredient,
  selected,
  onPress
}: {
  ingredient: Ingredient;
  selected?: boolean;
  onPress: () => void;
}) {
  return (
    <Pressable
      onPress={onPress}
      style={({ pressed }) => ({
        flex: 1,
        minWidth: "30%",
        borderRadius: radius.md,
        borderCurve: "continuous",
        backgroundColor: selected ? "#EEF5DE" : colors.white,
        borderWidth: 2,
        borderColor: selected ? colors.green : "transparent",
        padding: 12,
        alignItems: "center",
        gap: 8,
        opacity: pressed ? 0.78 : 1,
        ...shadow
      })}
    >
      <IngredientGlyph ingredient={ingredient} size={48} />
      <Text selectable style={{ color: selected ? colors.green : colors.ink, fontSize: 12, fontWeight: "800" }}>
        {ingredient.name}
      </Text>
    </Pressable>
  );
}

export function PantryRow({
  item,
  onDecrease,
  onIncrease
}: {
  item: PantryItem;
  onDecrease: () => void;
  onIncrease: () => void;
}) {
  const ingredient = getIngredient(item.ingredientId);
  if (!ingredient) return null;

  return (
    <View
      style={{
        flexDirection: "row",
        alignItems: "center",
        gap: 12,
        borderRadius: radius.md,
        borderCurve: "continuous",
        borderWidth: 1.5,
        borderColor: colors.red,
        padding: 10,
        backgroundColor: colors.yellow
      }}
    >
      <IngredientGlyph ingredient={ingredient} size={46} />
      <View style={{ flex: 1 }}>
        <Text selectable style={{ color: colors.ink, fontSize: 15, fontWeight: "800" }}>
          {ingredient.name}
        </Text>
        <Text selectable style={{ color: colors.muted, fontSize: 11 }}>
          {ingredient.category} • {ingredient.unit}
        </Text>
      </View>
      <QuantityButton label="-" onPress={onDecrease} />
      <Text selectable style={{ color: colors.red, minWidth: 24, textAlign: "center", fontWeight: "900" }}>
        {item.quantity}
      </Text>
      <QuantityButton label="+" onPress={onIncrease} />
    </View>
  );
}

function QuantityButton({ label, onPress }: { label: string; onPress: () => void }) {
  return (
    <Pressable
      onPress={onPress}
      style={({ pressed }) => ({
        width: 32,
        height: 32,
        borderRadius: 12,
        backgroundColor: colors.paper,
        borderWidth: 1,
        borderColor: colors.line,
        alignItems: "center",
        justifyContent: "center",
        opacity: pressed ? 0.65 : 1
      })}
    >
      <Text selectable style={{ color: colors.red, fontSize: 18, fontWeight: "900" }}>
        {label}
      </Text>
    </Pressable>
  );
}

export function RecipeCard({ recipe }: { recipe: Recipe }) {
  return (
    <Link href={`/recipe/${recipe.id}`} asChild>
      <Pressable
        style={({ pressed }) => ({
          flex: 1,
          minWidth: "47%",
          gap: 8,
          opacity: pressed ? 0.82 : 1,
          transform: [{ scale: pressed ? 0.99 : 1 }]
        })}
      >
        <RecipeVisual recipe={recipe} compact />
        <View style={{ gap: 2 }}>
          <Text selectable style={{ color: colors.red, fontSize: 13, fontWeight: "900" }}>
            {recipe.title}
          </Text>
          <Text selectable style={{ color: colors.muted, fontSize: 11 }}>
            {recipe.time} • {recipe.servings}
          </Text>
        </View>
      </Pressable>
    </Link>
  );
}

export function MetricPill({ label, value }: { label: string; value: string }) {
  return (
    <View
      style={{
        flex: 1,
        borderRadius: radius.md,
        borderCurve: "continuous",
        backgroundColor: colors.paper,
        padding: 14,
        borderWidth: 1,
        borderColor: colors.line
      }}
    >
      <Text selectable style={{ color: colors.red, fontSize: 18, fontWeight: "900" }}>
        {value}
      </Text>
      <Text selectable style={{ color: colors.muted, fontSize: 11, marginTop: 2 }}>
        {label}
      </Text>
    </View>
  );
}
