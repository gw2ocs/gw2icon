const gulp = require('gulp');
const buffer = require('vinyl-buffer');
const merge = require('merge-stream');
const spritesmith = require('gulp.spritesmith');
const imagemin = require('gulp-imagemin');
const sass = require('gulp-sass');
const sassLint = require('gulp-sass-lint');
const rename = require('gulp-rename');
const { dirname, resolve } = require('path');

const types = ['currencies', 'menu', 'characters', 'squad'];

types.map(type => {
    gulp.task(`sprite_${type}`, () => {
        const spriteData = gulp.src(`src/img/${type}/*.png`)
            .pipe(spritesmith({
		padding: 1,
                imgName: `${type}.png`,
                cssName: `_${type}.scss`,
                cssTemplate: 'icons.scss.handlebars',
                cssSpritesheetName: type,
                cssVarMap: (sprite) => {
                    const aliasesPath = resolve(dirname(sprite.source_image), 'aliases.json');
                    try {
                        sprite.aliases = require(aliasesPath)[sprite.name.replace(/_/g, '-')];
                    } catch(e) {
                        sprite.aliases = [];
                    }
                },
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

gulp.task('sass_lint', [...types.map(type => `sprite_${type}`), 'copy_src'], () => {
    return gulp.src('_build/scss/**/*.scss')
        .pipe(sassLint())
        .pipe(sassLint.format())
        .pipe(sassLint.failOnError());
});

gulp.task('sass', ['sass_lint'], () => {
    return gulp.src('_build/scss/*.scss')
        .pipe(sass({outputStyle: 'compressed'}).on('error', sass.logError))
		.pipe(rename({ suffix: '.min' }))
        .pipe(gulp.dest('_build/css'));
});

gulp.task('default', [...types.map(type => `sprite_${type}`), 'copy_src', 'sass_lint', 'sass']);
