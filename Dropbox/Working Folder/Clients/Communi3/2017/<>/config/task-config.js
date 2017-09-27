module.exports = {
    html: false,
    images: true,
    fonts: true,
    svgSprite: true,
    stylesheets: true,

    browserSync: {
        proxy: 'communi3.dev',
        files: ['app/**/*'],
    },

    javascripts: {
        publicPath: '/assets/javascripts',
        entry: {
            app: ['./app.js']
        }
    }
}
