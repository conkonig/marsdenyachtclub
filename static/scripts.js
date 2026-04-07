tailwind.config = {
  darkMode: "class",
  theme: {
    extend: {
      colors: {
        error: "#ba1a1a",
        secondary: "#904d00",
        "on-primary": "#ffffff",
        "primary-fixed": "#d5e3ff",
        "on-tertiary-container": "#e98024",
        "primary-container": "#003366",
        "on-error": "#ffffff",
        surface: "#fbfbe2",
        "tertiary-container": "#532700",
        "primary-fixed-dim": "#a7c8ff",
        "tertiary-fixed-dim": "#ffb783",
        "on-tertiary-fixed-variant": "#713700",
        "surface-container-high": "#eaead1",
        "error-container": "#ffdad6",
        outline: "#737780",
        "on-secondary-container": "#603100",
        "on-secondary-fixed-variant": "#6e3900",
        "surface-container-low": "#f5f5dc",
        "inverse-on-surface": "#f2f2d9",
        "on-error-container": "#93000a",
        "on-surface": "#1b1d0e",
        "on-primary-fixed-variant": "#1f477b",
        "surface-variant": "#e4e4cc",
        "on-secondary": "#ffffff",
        "on-surface-variant": "#43474f",
        "surface-bright": "#fbfbe2",
        "surface-container": "#efefd7",
        "surface-tint": "#3a5f94",
        "on-tertiary-fixed": "#301400",
        "inverse-surface": "#303221",
        "on-background": "#1b1d0e",
        tertiary: "#341600",
        "secondary-fixed": "#ffdcc3",
        background: "#fbfbe2",
        "surface-container-highest": "#e4e4cc",
        primary: "#001e40",
        "on-tertiary": "#ffffff",
        "on-secondary-fixed": "#2f1500",
        "tertiary-fixed": "#ffdcc5",
        "surface-dim": "#dbdcc3",
        "surface-container-lowest": "#ffffff",
        "outline-variant": "#c3c6d1",
        "on-primary-fixed": "#001b3c",
        "inverse-primary": "#a7c8ff",
        "on-primary-container": "#799dd6",
        "secondary-fixed-dim": "#ffb77d",
        "secondary-container": "#fd8b00",
        accent: "#e91e63"
      },
      borderRadius: {
        DEFAULT: "0.25rem",
        lg: "0.5rem",
        xl: "1.5rem",
        full: "9999px"
      },
      fontFamily: {
        headline: ["Plus Jakarta Sans", "sans-serif"],
        body: ["Manrope", "sans-serif"],
        label: ["Manrope", "sans-serif"]
      }
    }
  }
};

document.addEventListener("DOMContentLoaded", () => {
  const menuButtons = document.querySelectorAll("[data-menu-toggle]");
  const mobilePanels = document.querySelectorAll("[data-mobile-menu]");

  const setOpen = (open) => {
    mobilePanels.forEach((panel) => {
      panel.dataset.open = open ? "true" : "false";
      panel.classList.toggle("hidden", !open);
    });

    menuButtons.forEach((button) => {
      button.setAttribute("aria-expanded", open ? "true" : "false");
    });
  };

  setOpen(false);

  menuButtons.forEach((button) => {
    button.addEventListener("click", () => {
      const nextOpen = button.getAttribute("aria-expanded") !== "true";
      setOpen(nextOpen);
    });
  });

  document.addEventListener("keydown", (event) => {
    if (event.key === "Escape") {
      setOpen(false);
    }
  });
});
