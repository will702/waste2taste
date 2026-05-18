import { useRouter } from "expo-router";
import React from "react";
import { Pressable, Text, View } from "react-native";

import { AppButton } from "@/components/AppButton";
import { IngredientGlyph } from "@/components/FoodVisual";
import { Screen } from "@/components/Screen";
import { usePantry } from "@/context/PantryContext";
import { ingredients } from "@/data/catalog";
import { colors, radius, shadow } from "@/data/theme";

const detectedIds = ["tomato", "paprika", "chicken"];

export default function ScanScreen() {
  const router = useRouter();
  const { addDetectedPantry } = usePantry();
  const [agreed, setAgreed] = React.useState(false);
  const detected = ingredients.filter((ingredient) => detectedIds.includes(ingredient.id));

  return (
    <Screen scroll={false} contentStyle={{ paddingHorizontal: 24, justifyContent: "center", gap: 24 }}>
      <AppButton label="Back" variant="ghost" onPress={() => router.back()} style={{ position: "absolute", top: 62, left: 22, minHeight: 38 }} />

      <View style={{ alignItems: "center", gap: 18 }}>
        <View
          style={{
            width: 132,
            height: 132,
            borderRadius: 66,
            backgroundColor: colors.red,
            alignItems: "center",
            justifyContent: "center",
            ...shadow
          }}
        >
          <View
            style={{
              width: 62,
              height: 46,
              borderRadius: 18,
              borderCurve: "continuous",
              borderWidth: 5,
              borderColor: colors.cream
            }}
          />
        </View>
        <Pressable onPress={() => setAgreed((value) => !value)} style={{ flexDirection: "row", alignItems: "center", gap: 10 }}>
          <View
            style={{
              width: 22,
              height: 22,
              borderRadius: 8,
              borderCurve: "continuous",
              borderWidth: 2,
              borderColor: colors.red,
              backgroundColor: agreed ? colors.red : "transparent"
            }}
          />
          <Text selectable style={{ color: colors.red, fontWeight: "800" }}>
            Agree to use camera
          </Text>
        </Pressable>
      </View>

      <View style={{ alignItems: "center", gap: 8 }}>
        <Text selectable style={{ color: colors.green, fontSize: 26, fontWeight: "900", textAlign: "center" }}>
          Let&apos;s Start Scanning
        </Text>
        <Text selectable style={{ color: colors.muted, fontSize: 14, lineHeight: 21, textAlign: "center" }}>
          This prototype simulates a camera result and adds the detected items to your pantry.
        </Text>
      </View>

      <View
        style={{
          borderRadius: radius.xl,
          borderCurve: "continuous",
          backgroundColor: colors.red,
          padding: 18,
          gap: 14
        }}
      >
        <Text selectable style={{ color: colors.cream, fontSize: 16, fontWeight: "900" }}>
          Detected ingredients
        </Text>
        <View style={{ flexDirection: "row", gap: 10 }}>
          {detected.map((ingredient) => (
            <View key={ingredient.id} style={{ flex: 1, alignItems: "center", gap: 7 }}>
              <IngredientGlyph ingredient={ingredient} />
              <Text selectable style={{ color: colors.cream, fontSize: 11, fontWeight: "800", textAlign: "center" }}>
                {ingredient.name}
              </Text>
            </View>
          ))}
        </View>
        <AppButton
          label={agreed ? "Add Detected Items" : "Allow Camera First"}
          variant="cream"
          onPress={() => {
            if (!agreed) {
              setAgreed(true);
              return;
            }
            addDetectedPantry();
            router.replace("/home");
          }}
        />
        <AppButton label="Type ingredients instead" variant="ghost" onPress={() => router.push("/add-ingredients")} />
      </View>
    </Screen>
  );
}
