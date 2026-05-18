import { useRouter } from "expo-router";
import React from "react";
import { Text, TextInput, View } from "react-native";

import { AppButton } from "@/components/AppButton";
import { IngredientChip, SectionTitle } from "@/components/Cards";
import { Screen } from "@/components/Screen";
import { usePantry } from "@/context/PantryContext";
import { ingredients } from "@/data/catalog";
import { colors } from "@/data/theme";

export default function AddIngredientsScreen() {
  const router = useRouter();
  const { addIngredients } = usePantry();
  const [query, setQuery] = React.useState("");
  const [selected, setSelected] = React.useState<string[]>([]);
  const filtered = ingredients.filter((ingredient) =>
    ingredient.name.toLowerCase().includes(query.trim().toLowerCase())
  );

  function toggle(id: string) {
    setSelected((current) => (current.includes(id) ? current.filter((item) => item !== id) : [...current, id]));
  }

  return (
    <Screen contentStyle={{ paddingBottom: 30 }}>
      <View
        style={{
          backgroundColor: colors.red,
          marginHorizontal: -20,
          marginTop: -60,
          paddingTop: 72,
          paddingHorizontal: 20,
          paddingBottom: 22,
          borderBottomLeftRadius: 30,
          borderBottomRightRadius: 30,
          borderCurve: "continuous",
          gap: 14
        }}
      >
        <AppButton label="Back" variant="cream" onPress={() => router.back()} style={{ alignSelf: "flex-start", minHeight: 38 }} />
        <Text selectable style={{ color: colors.cream, fontSize: 24, fontWeight: "900" }}>
          Add Ingredients
        </Text>
      </View>

      <TextInput
        value={query}
        onChangeText={setQuery}
        placeholder="Search ingredient..."
        placeholderTextColor="#B38B63"
        style={{
          minHeight: 54,
          borderRadius: 28,
          backgroundColor: colors.white,
          paddingHorizontal: 18,
          fontSize: 15,
          color: colors.ink
        }}
      />

      <SectionTitle title="Popular ingredients" />
      <View style={{ flexDirection: "row", flexWrap: "wrap", gap: 10 }}>
        {filtered.map((ingredient) => (
          <IngredientChip
            key={ingredient.id}
            ingredient={ingredient}
            selected={selected.includes(ingredient.id)}
            onPress={() => toggle(ingredient.id)}
          />
        ))}
      </View>
      <Text selectable style={{ color: colors.green, textAlign: "center", fontWeight: "800" }}>
        Selected: {selected.length} ingredient{selected.length === 1 ? "" : "s"}
      </Text>
      <AppButton
        label="Add to My List"
        onPress={() => {
          addIngredients(selected);
          router.back();
        }}
      />
    </Screen>
  );
}
