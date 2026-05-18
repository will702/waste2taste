import { Text, View } from "react-native";

import { AppButton } from "@/components/AppButton";
import { BrandMark } from "@/components/BrandMark";
import { MetricPill, SectionTitle } from "@/components/Cards";
import { Screen } from "@/components/Screen";
import { colors, radius } from "@/data/theme";

export default function ProfileScreen() {
  return (
    <Screen contentStyle={{ paddingBottom: 104 }}>
      <View
        style={{
          borderRadius: radius.xl,
          borderCurve: "continuous",
          backgroundColor: colors.red,
          padding: 22,
          gap: 18
        }}
      >
        <BrandMark compact light />
        <View style={{ gap: 4 }}>
          <Text selectable style={{ color: colors.cream, fontSize: 24, fontWeight: "900" }}>
            Alvina
          </Text>
          <Text selectable style={{ color: "rgba(255,220,157,0.78)", fontSize: 13 }}>
            Home cook • Waste saver • Jakarta
          </Text>
        </View>
      </View>

      <View style={{ flexDirection: "row", gap: 12 }}>
        <MetricPill label="weekly saves" value="5" />
        <MetricPill label="favorite" value="Rice" />
      </View>

      <SectionTitle title="Preferences" />
      <View style={{ gap: 10 }}>
        {["Vegetable-first recipes", "Quick meals under 30 min", "Indonesian comfort flavors"].map((item) => (
          <View
            key={item}
            style={{
              borderRadius: radius.md,
              borderCurve: "continuous",
              backgroundColor: colors.paper,
              padding: 16,
              borderWidth: 1,
              borderColor: colors.line
            }}
          >
            <Text selectable style={{ color: colors.ink, fontSize: 14, fontWeight: "800" }}>
              {item}
            </Text>
          </View>
        ))}
      </View>
      <AppButton label="Edit Profile" variant="ghost" onPress={() => undefined} />
    </Screen>
  );
}
