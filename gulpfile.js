const gulp = require('gulp');
const buffer = require('vinyl-buffer');
const merge = require('merge-stream');
const spritesmith = require('gulp.spritesmith');
const imagemin = require('gulp-imagemin');

gulp.task('sprite', () => {
    const type = 'currencies';
    const spriteData = gulp.src(`src/img/${type}/*.png`)
        .pipe(spritesmith({
            /* this whole image path is used in css background declarations */
            imgName: `${type}.png`,
            cssName: `${type}.scss`,
            cssTemplate: 'scss-icons.handlebars',
            cssSpritesheetName: type
        }));

    const imgStream = spriteData.img
        .pipe(buffer())
        .pipe(imagemin())
        .pipe(gulp.dest('_build/img'));

    const cssStream = spriteData.css
        .pipe(gulp.dest('_build/css'));

    return merge(imgStream, cssStream);
});

gulp.task('default', ['sprite']);