import type React from "react";
import { ScrollView, View, type ViewStyle } from "react-native";
import { useSafeAreaInsets } from "react-native-safe-area-context";

import { colors } from "@/data/theme";

type ScreenProps = {
  children: React.ReactNode;
  scroll?: boolean;
  backgroundColor?: string;
  contentStyle?: ViewStyle;
};

export function Screen({
  children,
  scroll = true,
  backgroundColor = colors.yellow,
  contentStyle
}: ScreenProps) {
  const insets = useSafeAreaInsets();
  const shell = {
    width: "100%" as const,
    maxWidth: 430,
    alignSelf: "center" as const
  };

  if (!scroll) {
    return (
      <View style={{ flex: 1, backgroundColor, alignItems: "center" }}>
        <View
          style={[
            shell,
            {
              flex: 1,
              paddingTop: insets.top,
              paddingBottom: insets.bottom
            },
            contentStyle
          ]}
        >
          {children}
        </View>
      </View>
    );
  }

  return (
    <ScrollView
      style={{ flex: 1, backgroundColor }}
      contentInsetAdjustmentBehavior="automatic"
      showsVerticalScrollIndicator={false}
      contentContainerStyle={[
        {
          ...shell,
          paddingTop: insets.top + 18,
          paddingHorizontal: 20,
          paddingBottom: insets.bottom + 28,
          gap: 18
        },
        contentStyle
      ]}
    >
      {children}
    </ScrollView>
  );
}
