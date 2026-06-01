import { Ionicons } from "@expo/vector-icons";
import { Tabs } from "expo-router";

import { colors } from "@/data/theme";

type TabName = "home" | "recipes" | "history" | "profile";

const tabIcons: Record<TabName, { active: keyof typeof Ionicons.glyphMap; inactive: keyof typeof Ionicons.glyphMap }> = {
  home:    { active: "home",   inactive: "home-outline" },
  recipes: { active: "book",   inactive: "book-outline" },
  history: { active: "time",   inactive: "time-outline" },
  profile: { active: "person", inactive: "person-outline" }
};

export default function TabsLayout() {
  return (
    <Tabs
      screenOptions={({ route }) => ({
        headerShown: false,
        tabBarShowLabel: false,
        tabBarStyle: {
          position: "absolute",
          left: "4%",
          right: "4%",
          bottom: 14,
          height: 62,
          borderRadius: 31,
          borderCurve: "continuous",
          backgroundColor: colors.green,
          borderTopWidth: 0,
          boxShadow: "0 8px 28px rgba(0,0,0,0.28)"
        },
        tabBarIcon: ({ focused }) => {
          const icons = tabIcons[route.name as TabName];
          if (!icons) return null;
          return (
            <Ionicons
              name={focused ? icons.active : icons.inactive}
              size={22}
              color={focused ? colors.white : "rgba(255,255,255,0.42)"}
            />
          );
        }
      })}
    >
      <Tabs.Screen name="home" options={{ title: "Home" }} />
      <Tabs.Screen name="recipes" options={{ title: "Recipes" }} />
      <Tabs.Screen name="history" options={{ title: "History" }} />
      <Tabs.Screen name="profile" options={{ title: "Profile" }} />
    </Tabs>
  );
}
