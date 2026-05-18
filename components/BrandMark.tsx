import { Text, View } from "react-native";

import { colors } from "@/data/theme";

export function BrandMark({ compact = false, light = false }: { compact?: boolean; light?: boolean }) {
  const ink = light ? colors.cream : colors.green;
  const accent = light ? colors.yellow : colors.red;

  return (
    <View style={{ alignItems: "center", gap: compact ? 2 : 6 }}>
      <View style={{ flexDirection: "row", alignItems: "center", gap: 8 }}>
        <View
          style={{
            width: compact ? 32 : 44,
            height: compact ? 32 : 44,
            borderRadius: 14,
            borderCurve: "continuous",
            backgroundColor: accent,
            alignItems: "center",
            justifyContent: "center",
            transform: [{ rotate: "-8deg" }]
          }}
        >
          <View
            style={{
              width: compact ? 15 : 20,
              height: compact ? 20 : 26,
              borderTopLeftRadius: 12,
              borderTopRightRadius: 2,
              borderBottomLeftRadius: 12,
              borderBottomRightRadius: 12,
              backgroundColor: light ? colors.green : colors.cream
            }}
          />
        </View>
        <Text
          selectable
          style={{
            color: ink,
            fontSize: compact ? 24 : 38,
            fontWeight: "900",
            letterSpacing: 0
          }}
        >
          Waste2Taste
        </Text>
      </View>
      {!compact ? (
        <Text selectable style={{ color: light ? "rgba(255,220,157,0.76)" : colors.muted, fontSize: 13 }}>
          Sustainable bites, delightful flavors.
        </Text>
      ) : null}
    </View>
  );
}
