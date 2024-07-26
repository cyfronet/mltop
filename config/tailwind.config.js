const defaultTheme = require('tailwindcss/defaultTheme')

module.exports = {
  content: [
    './public/*.html',
    './app/helpers/**/*.rb',
    './app/javascript/**/*.js',
    './app/views/**/*.{erb,haml,html,slim}',
    './lib/form_builders/**/*.rb',
  ],
  theme: {
    extend: {
      animation: {
        'appear-then-fade': 'appear-then-fade 3s both',
      },
      keyframes: {
        'appear-then-fade': {
          '0%, 100%': { opacity: '0' },
          '5%, 60%': { opacity: '1' },
        }
      },
      fontFamily: {
        sans: ['Inter var', ...defaultTheme.fontFamily.sans],
      },
    },
  },
  plugins: [
    require('@tailwindcss/forms'),
    require('@tailwindcss/aspect-ratio'),
    require('@tailwindcss/typography'),
    require('@tailwindcss/container-queries'),
  ]
}
