const gulp = require('gulp');
const buffer = require('vinyl-buffer');
const merge = require('merge-stream');
const spritesmith = require('gulp.spritesmith');
const imagemin = require('gulp-imagemin');
const sass = require('gulp-sass');

const types = ['currencies', 'menu', 'characters'];

types.map(type => {
    gulp.task(`sprite_${type}`, () => {
        const spriteData = gulp.src(`src/img/${type}/*.png`)
            .pipe(spritesmith({
                imgName: `${type}.png`,
                cssName: `_${type}.scss`,
                cssTemplate: 'icons.scss.handlebars',
                cssSpritesheetName: type,
            }));

        const imgStream = spriteData.img
            .pipe(buffer())
            .pipe(imagemin())
            .pipe(gulp.dest('_build/img/gw2icon'));

        const cssStream = spriteData.css
            .pipe(gulp.dest('_build/scss/icons'));

        return merge(imgStream, cssStream);
    });
});

gulp.task('copy_src', () => {
	return gulp.src('src/scss/*.scss')
		.pipe(gulp.dest('_build/scss'));
});

gulp.task('sass', [...types.map(type => `sprite_${type}`)], () => {
	return gulp.src('_build/scss/*.scss')
	    .pipe(sass({outputStyle: 'compressed'}).on('error', sass.logError))
	    .pipe(gulp.dest('_build/css'));
})

gulp.task('default', [...types.map(type => `sprite_${type}`), 'copy_src', 'sass']);
