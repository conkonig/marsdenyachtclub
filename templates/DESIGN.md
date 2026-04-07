# Design System Strategy: High-End Nautical Editorial

## 1. Overview & Creative North Star

### Creative North Star: "The Coastal Curator"
This design system moves away from the rigid, boxy templates often associated with community clubs. Instead, it adopts the persona of a high-end maritime journal. The objective is to capture the "sun-drenched" warmth of New Zealand’s Marsden Cove by blending professional nautical authority with the organic ease of coastal living.

The layout breaks the standard digital "grid-lock" through **intentional layering**. Elements should feel as though they are floating on the water—using staggered card placements, overlapping typography, and deep tonal transitions rather than structural lines. This system prioritizes breathing room (white space) to mimic the vastness of the ocean, ensuring the interface feels premium, inviting, and uncluttered.

---

## 2. Colors

The palette is anchored by the deep stability of the Pacific Ocean and the vibrant energy of a Northland sunset. 

### The Palette Logic
- **Primary & Containers:** `primary` (#001e40) and `primary_container` (#003366) provide the nautical weight. Use these for high-authority sections and navigation.
- **The Sunset Gradient:** A signature transition from `secondary_container` (#fd8b00) to `on_tertiary_container` (#e98024). This is the "soul" of the brand—use it sparingly for high-impact Hero areas and primary CTAs.
- **Neutrals:** `surface` (#fbfbe2) and `surface_container_low` (#f5f5dc) represent the sandy shore. They are the foundation of the editorial feel.

### The "No-Line" Rule
To maintain a high-end feel, **1px solid borders are strictly prohibited** for sectioning. Boundaries must be defined solely through:
1.  **Tonal Shifts:** Placing a `surface_container_high` card on a `surface` background.
2.  **Negative Space:** Using generous margins to define content groupings.

### Glassmorphism & Signature Textures
For floating elements like "Quick Links" or "Weather Widgets" over photography, use the **Glassmorphism Rule**: Apply `surface_container_lowest` at 70% opacity with a `24px` backdrop blur. This creates an integrated, sun-bleached look that feels modern and lightweight.

---

## 3. Typography

The typography scale is designed for readability against high-contrast backgrounds and to establish a clear editorial hierarchy.

- **Display & Headlines (Plus Jakarta Sans):** These are the "shouts" of the system. The bold, modern sans-serif nature conveys confidence. Use `display-lg` for hero statements, ensuring tight letter-spacing for a custom, intentional feel.
- **Titles & Body (Manrope):** Manrope provides a technical yet friendly balance. `body-lg` (1rem) is the workhorse. Ensure line heights are generous (1.6x) to facilitate the "inviting" vibe.
- **Labeling:** Use `label-md` for metadata (dates, categories). Always pair these with increased letter-spacing (tracking) to differentiate them from functional body text.

---

## 4. Elevation & Depth

In "The Coastal Curator," depth is a result of light and layering, not artificial structure.

### The Layering Principle
Hierarchy is achieved by "stacking" surface tiers.
- **Base Level:** `surface` (#fbfbe2).
- **Sub-Sections:** `surface_container_low` (#f5f5dc).
- **Interactive Cards:** `surface_container_lowest` (#ffffff).
By nesting these, you create a natural lift that mimics fine stationery.

### Ambient Shadows
Shadows must never be "black." When a floating effect is required, use a shadow color derived from the `on_surface` token (#1b1d0e) at a **4% - 6% opacity**. 
*   **Blur:** High (32px to 64px).
*   **Spread:** Negative values to keep the shadow "tucked" under the element.

### The "Ghost Border" Fallback
If a border is required for accessibility (e.g., input fields), use the `outline_variant` at **20% opacity**. Avoid 100% opaque lines at all costs.

---

## 5. Components

### Buttons
- **Primary:** Gradient fill (`secondary_container` to `on_tertiary_container`) with `on_primary` text. Use `rounded-full` (9999px) for a modern, friendly feel.
- **Secondary:** `primary_container` background with a subtle "Ghost Border."
- **Tertiary/Ghost:** No background. Underline on hover only.

### Editorial Cards
Cards are the primary vehicle for content. 
- **Style:** `rounded-xl` (1.5rem), `surface_container_lowest` background.
- **Rule:** Forbid divider lines. Use `spacing-lg` (1.5rem) to separate the image, title, and body text within the card.

### Input Fields
- **Background:** `surface_container_highest` (#e4e4cc).
- **Shape:** `rounded-md` (0.75rem).
- **Interaction:** On focus, transition the background to `surface_container_lowest` and add a subtle `primary` glow.

### Nautical Chips
- Use for "Event Categories" or "Boat Types." 
- **Style:** Small, pill-shaped, using `surface_variant` with `on_surface_variant` text. High-end editorial looks often use "all-caps" for these chips.

---

## 6. Do's and Don'ts

### Do:
- **Do** overlap elements. Allow a card to partially sit over a hero image to create a sense of depth and continuity.
- **Do** use large photography of the ocean and marina as a background for typography, ensuring a `primary_container` overlay for legibility.
- **Do** utilize the `surface_dim` and `surface_bright` tokens to create a "weathered" or "sun-drenched" effect in secondary pages.

### Don't:
- **Don't** use standard 1px grey borders. It breaks the premium "curated" feel.
- **Don't** crowd the layout. If in doubt, add more whitespace between sections.
- **Don't** use pure black (#000000) for text. Always use `on_surface` or `primary` to maintain the tonal nautical depth.
- **Don't** use sharp 90-degree corners. Everything in the marine environment is softened by the elements; our UI should reflect that with the `xl` and `lg` roundedness scale.