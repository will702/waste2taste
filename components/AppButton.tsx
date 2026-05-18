import * as Haptics from "expo-haptics";
import { Pressable, Text, type ViewStyle } from "react-native";

import { colors } from "@/data/theme";

type AppButtonProps = {
  label: string;
  onPress: () => void;
  variant?: "primary" | "red" | "cream" | "ghost";
  style?: ViewStyle;
};

export function AppButton({ label, onPress, variant = "primary", style }: AppButtonProps) {
  const palette = {
    primary: { backgroundColor: colors.green, color: colors.cream, borderColor: colors.green },
    red: { backgroundColor: colors.red, color: colors.cream, borderColor: colors.red },
    cream: { backgroundColor: colors.cream, color: colors.green, borderColor: colors.cream },
    ghost: { backgroundColor: "transparent", color: colors.red, borderColor: colors.red }
  }[variant];

  return (
    <Pressable
      onPress={() => {
        if (process.env.EXPO_OS === "ios") {
          Haptics.selectionAsync().catch(() => undefined);
        }
        onPress();
      }}
      style={({ pressed }) => [
        {
          minHeight: 52,
          borderRadius: 28,
          borderWidth: variant === "ghost" ? 1.5 : 0,
          borderColor: palette.borderColor,
          backgroundColor: palette.backgroundColor,
          alignItems: "center",
          justifyContent: "center",
          paddingHorizontal: 18,
          opacity: pressed ? 0.78 : 1,
          transform: [{ scale: pressed ? 0.98 : 1 }]
        },
        style
      ]}
    >
      <Text selectable style={{ color: palette.color, fontSize: 15, fontWeight: "800" }}>
        {label}
      </Text>
    </Pressable>
  );
}
