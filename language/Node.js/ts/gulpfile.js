const gulp = require("gulp");
const ts = require("gulp-typescript");
const sourcemaps = require('gulp-sourcemaps');
const watch = require('gulp-watch');
const del = require('del');
const tsProject = ts.createProject("tsconfig.json");

function compile() {
    return tsProject.src()

        .pipe(sourcemaps.init())
        .pipe(tsProject())
        .pipe(sourcemaps.mapSources((sourcePath, file) => {
            const depth = sourcePath.match(new RegExp("\/", "g")).length - 2;
            return new Array(depth).fill('../').concat() + sourcePath;
        }))
        .pipe(sourcemaps.write())
        .pipe(gulp.dest("dist"));
}

function cleanUp() {
    return del([
        'dist/**/*'
    ]);
}

function watchify() {
    // Callback mode, useful if any plugin in the pipeline depends on the `end`/`flush` event
    return watch('src/**/*.ts', gulp.series([cleanUp, compile]));
}

gulp.task(compile);

gulp.task('default', gulp.series(watchify));