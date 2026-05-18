import { Tabs } from "expo-router";
import { Text, View } from "react-native";

import { colors } from "@/data/theme";

const tabs = {
  home: "Home",
  recipes: "Recipes",
  history: "History",
  profile: "Profile"
};

export default function TabsLayout() {
  return (
    <Tabs
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarShowLabel: false,
        tabBarStyle: {
          position: "absolute",
          left: "50%",
          bottom: 14,
          width: "92%",
          maxWidth: 402,
          transform: [{ translateX: -201 }],
          height: 62,
          borderRadius: 31,
          borderCurve: "continuous",
          backgroundColor: colors.green,
          borderTopWidth: 0,
          boxShadow: "0 8px 28px rgba(0,0,0,0.28)"
        },
        tabBarIcon: ({ focused }) => (
          <View style={{ alignItems: "center", justifyContent: "center", gap: 5 }}>
            <Text selectable style={{ color: focused ? colors.white : "rgba(255,255,255,0.42)", fontSize: 12, fontWeight: "900" }}>
              {tabs[route.name as keyof typeof tabs]?.slice(0, 1)}
            </Text>
            <View
              style={{
                width: 18,
                height: 3,
                borderRadius: 2,
                backgroundColor: focused ? colors.white : "transparent"
              }}
            />
          </View>
        )
      })}
    >
      <Tabs.Screen name="home" options={{ title: "Home" }} />
      <Tabs.Screen name="recipes" options={{ title: "Recipes" }} />
      <Tabs.Screen name="history" options={{ title: "History" }} />
      <Tabs.Screen name="profile" options={{ title: "Profile" }} />
    </Tabs>
  );
}
