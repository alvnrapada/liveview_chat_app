module.exports = {
 purge: [
    '../lib/**/*.ex',
    '../lib/**/*.leex',
    '../lib/**/*.eex',
    './js/**/*.js'
  ],
  darkMode: false, // or 'media' or 'class'
  theme: {
    extend: {},
  },
  variants: {
    extend: {
      backgroundColor: ["responsive", "hover", "focus", "disabled", "checked"],
      borderColor: ["responsive", "hover", "focus", "checked"],
      borderStyle: ["responsive", "disabled", "checked"],
      boxShadow: ["responsive", "hover", "focus", "disabled", "checked"],
      cursor: ["responsive", "hover"],
      textColor: ["responsive", "hover", "focus", "checked"],
      padding: ["responsive", "disabled"],
    },
  },
  plugins: [],
}
