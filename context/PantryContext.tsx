import * as Haptics from "expo-haptics";
import React from "react";

import { initialPantry } from "@/data/catalog";
import type { PantryItem } from "@/types/app";

type PantryContextValue = {
  pantry: PantryItem[];
  addIngredients: (ids: string[]) => void;
  addDetectedPantry: () => void;
  changeQuantity: (id: string, delta: number) => void;
  removeIngredient: (id: string) => void;
  hasIngredient: (id: string) => boolean;
};

const PantryContext = React.createContext<PantryContextValue | null>(null);

function tap() {
  if (process.env.EXPO_OS === "ios") {
    Haptics.selectionAsync().catch(() => undefined);
  }
}

export function PantryProvider({ children }: { children: React.ReactNode }) {
  const [pantry, setPantry] = React.useState<PantryItem[]>(initialPantry);

  const addIngredients = React.useCallback((ids: string[]) => {
    if (ids.length === 0) return;
    tap();
    setPantry((current) => {
      const next = [...current];
      ids.forEach((id) => {
        const existing = next.find((item) => item.ingredientId === id);
        if (existing) {
          existing.quantity += 1;
        } else {
          next.push({ ingredientId: id, quantity: 1 });
        }
      });
      return next;
    });
  }, []);

  const addDetectedPantry = React.useCallback(() => {
    addIngredients(["tomato", "paprika", "chicken"]);
  }, [addIngredients]);

  const changeQuantity = React.useCallback((id: string, delta: number) => {
    tap();
    setPantry((current) =>
      current
        .map((item) =>
          item.ingredientId === id
            ? { ...item, quantity: Math.max(0, item.quantity + delta) }
            : item
        )
        .filter((item) => item.quantity > 0)
    );
  }, []);

  const removeIngredient = React.useCallback((id: string) => {
    tap();
    setPantry((current) => current.filter((item) => item.ingredientId !== id));
  }, []);

  const hasIngredient = React.useCallback(
    (id: string) => pantry.some((item) => item.ingredientId === id),
    [pantry]
  );

  const value = React.useMemo(
    () => ({ pantry, addIngredients, addDetectedPantry, changeQuantity, removeIngredient, hasIngredient }),
    [pantry, addIngredients, addDetectedPantry, changeQuantity, removeIngredient, hasIngredient]
  );

  return <PantryContext.Provider value={value}>{children}</PantryContext.Provider>;
}

export function usePantry() {
  const value = React.useContext(PantryContext);
  if (!value) {
    throw new Error("usePantry must be used within PantryProvider");
  }
  return value;
}
