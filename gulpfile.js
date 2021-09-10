'use strict';

const
    {src, dest, watch, series} = require('gulp'),
    sass = require('gulp-sass'),
    cleancss = require('gulp-clean-css'),
    postcss = require('gulp-postcss'),
    autoprefixer = require('autoprefixer'),
    uglify = require('gulp-uglify'),
    babel = require('gulp-babel'),
    bump = require('gulp-bump'),
    semver = require('semver'),
    info = require('./package.json'),
    touch = require('gulp-touch-cmd')

;

function css() {
    return src('./src/sass/*.scss', {
            sourcemaps: false
        })
        .pipe(sass())
        .pipe(postcss([autoprefixer()]))
        .pipe(cleancss())
        .pipe(dest('./assets/css'))
	.pipe(touch());
}
function cssdev() {
    return src('./src/sass/*.scss', {
            sourcemaps: true
        })
        .pipe(sass())
        .pipe(postcss([autoprefixer()]))
        .pipe(dest('./assets/css'))
	.pipe(touch());
}

function js() {
    return src('./src/js/*.js')
        .pipe(babel({
            presets: ['@babel/env']
        }))
        .pipe(uglify())
        .pipe(dest('./assets/js'))
	.pipe(touch());
}

function patchPackageVersion() {
    var newVer = semver.inc(info.version, 'patch');
    return src(['./package.json', './' + info.main])
        .pipe(bump({
            version: newVer
        }))
        .pipe(dest('./'))
	.pipe(touch());
};

function devPackageVersion() {
    var newVer = semver.inc(info.version, 'prerelease');
    return src(['./package.json', './' + info.main])
        .pipe(bump({
            version: newVer
        }))
        .pipe(dest('./'))
	.pipe(touch());
};

function startWatch() {
    watch('./src/sass/*.scss', css);
    watch('./src/js/*.js', js);
}

exports.css = css;
exports.js = js;

exports.devversion = devPackageVersion;
exports.patchversion = patchPackageVersion;
exports.dev = series(js, cssdev, devPackageVersion);
exports.build = series(js, css, patchPackageVersion);
exports.default = startWatch;
