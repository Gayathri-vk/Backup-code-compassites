<?php
/**
 * The Header for our theme
 *
 * Displays all of the <head> section and everything up till <div id="main">
 *
 * @package WordPress
 * @subpackage Twenty_Fourteen
 * @since Twenty Fourteen 1.0
 */
?><!DOCTYPE html>
<!--[if IE 7]>
<html class="ie ie7" <?php language_attributes(); ?>>
<![endif]-->
<!--[if IE 8]>
<html class="ie ie8" <?php language_attributes(); ?>>
<![endif]-->
<!--[if !(IE 7) & !(IE 8)]><!-->
<html <?php language_attributes(); ?>>
<!--<![endif]-->
<head>
	<meta charset="<?php bloginfo( 'charset' ); ?>">
	<meta name="viewport" content="width=device-width">
	<meta http-equiv="X-UA-Compatible" content="IE=edge" />
	<meta name="viewport" content="width=device-width, initial-scale=1">
	<title><?php wp_title( '|', true, 'right' ); ?></title>
	<link rel="profile" href="http://gmpg.org/xfn/11">
	<link rel="pingback" href="<?php bloginfo( 'pingback_url' ); ?>">
	<!--[if lt IE 9]>
	<script src="<?php echo get_template_directory_uri(); ?>/js/html5.js"></script>
	<![endif]-->
	<link href="https://stackpath.bootstrapcdn.com/font-awesome/4.7.0/css/font-awesome.min.css" rel="stylesheet" integrity="sha384-wvfXpqpZZVQGK6TAh5PVlGOfQNHSoD2xbE+QkPxCAFlNEevoEH3Sl0sibVcOQVnN" crossorigin="anonymous">
	<link rel="stylesheet" type="text/css" href="https://stackpath.bootstrapcdn.com/bootstrap/4.1.3/css/bootstrap.min.css">
	<link rel="stylesheet" href="<?php echo get_template_directory_uri(); ?>/css/animate.css">
	<link rel="stylesheet" type="text/css" href="<?php echo get_template_directory_uri(); ?>/css/custom.css">
	<?php wp_head(); ?>
</head>

<body <?php body_class(); ?>>

<div id="page" class="hfeed site">
	<div class="site-loadingWrap">
		<div class="site-loading">
		</div>
	</div>
	<header>
		<div class="container-fluid">
			<div class="clearfix">
				<div class="pull-left logo-wrap">
					<a href="">
						<img src="<?php echo get_template_directory_uri(); ?>/img/logo_white.png">
					</a>
				</div>
				<div class="pull-right header-menu">
					<span class="header-login">LOG IN</span>
					<i class="fa fa-bars openMenu"></i>
				</div>
			</div>
		</div>
	</header>
	<aside>
		<div class="login-space">
			<span class="aside-menu">LOG IN</span>
			<i class="fa fa-bars closeMenu"></i>
		</div>
		<ul class="list-fields">
			<li>
				<a href="">Product</a>
			</li>
			<li>
				<a  class="about-click">About us</a>
			</li>
			<li>
				<a  class ="contact-click">Contact</a>
			</li>
			<li>
				<a href="">Resources</a>
			</li>
			<li>
				<a href="">Log in</a>
			</li>
		</ul>
		<p>DATA.<br/>AUTOMATED.<br/>INTELLIGENTLY.</p>
	</aside>
	
