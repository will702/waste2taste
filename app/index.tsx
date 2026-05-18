import { useRouter } from "expo-router";
import { Text, View } from "react-native";

import { AppButton } from "@/components/AppButton";
import { BrandMark } from "@/components/BrandMark";
import { RecipeVisual } from "@/components/FoodVisual";
import { Screen } from "@/components/Screen";
import { recipes } from "@/data/catalog";
import { colors } from "@/data/theme";

export default function LandingScreen() {
  const router = useRouter();

  return (
    <Screen scroll={false} backgroundColor={colors.yellow} contentStyle={{ justifyContent: "space-between" }}>
      <View style={{ flex: 1, justifyContent: "center", paddingHorizontal: 24, paddingTop: 42 }}>
        <BrandMark />
      </View>
      <View
        style={{
          backgroundColor: colors.red,
          borderTopLeftRadius: 44,
          borderTopRightRadius: 44,
          borderCurve: "continuous",
          paddingHorizontal: 24,
          paddingTop: 34,
          paddingBottom: 28,
          gap: 24
        }}
      >
        <RecipeVisual recipe={recipes[0]} />
        <View style={{ gap: 10 }}>
          <Text selectable style={{ color: colors.cream, fontSize: 32, lineHeight: 40, fontWeight: "900" }}>
            Sustainable bites,
            {"\n"}delightful flavors.
          </Text>
          <Text selectable style={{ color: "rgba(255,220,157,0.78)", fontSize: 14, lineHeight: 21 }}>
            Turn ingredients you already own into practical recipes before food goes to waste.
          </Text>
        </View>
        <AppButton label="Get Started" variant="cream" onPress={() => router.push("/login")} />
      </View>
    </Screen>
  );
}
