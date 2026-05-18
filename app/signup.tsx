import { useRouter } from "expo-router";
import { Text, TextInput, View } from "react-native";

import { AppButton } from "@/components/AppButton";
import { Screen } from "@/components/Screen";
import { colors } from "@/data/theme";

export default function SignupScreen() {
  const router = useRouter();

  return (
    <Screen backgroundColor={colors.red} contentStyle={{ paddingHorizontal: 0, paddingTop: 0, gap: 0 }}>
      <View style={{ paddingTop: 60, paddingHorizontal: 24, paddingBottom: 20 }}>
        <AppButton label="Back to login" variant="ghost" onPress={() => router.back()} style={{ alignSelf: "flex-start", minHeight: 38 }} />
      </View>
      <View
        style={{
          flex: 1,
          backgroundColor: colors.yellow,
          borderTopLeftRadius: 36,
          borderTopRightRadius: 36,
          borderCurve: "continuous",
          padding: 24,
          gap: 14
        }}
      >
        <Text selectable style={{ color: colors.green, fontSize: 38, fontWeight: "900" }}>
          Sign Up
        </Text>
        {["Email", "Password", "Confirm Password", "Phone"].map((placeholder) => (
          <TextInput
            key={placeholder}
            placeholder={placeholder}
            secureTextEntry={placeholder.includes("Password")}
            keyboardType={placeholder === "Phone" ? "phone-pad" : "default"}
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
        ))}
        <Text selectable style={{ color: colors.green, fontSize: 13, lineHeight: 19 }}>
          By continuing, you agree with Waste2Taste&apos;s privacy policy.
        </Text>
        <AppButton label="Create Account" onPress={() => router.replace("/home")} />
        <Text selectable style={{ color: colors.red, textAlign: "center" }}>
          Already have an account?{" "}
          <Text onPress={() => router.back()} style={{ color: colors.green, fontWeight: "900" }}>
            Sign In
          </Text>
        </Text>
      </View>
    </Screen>
  );
}
