<?php
/**
 * The template for displaying the footer
 *
 * Contains footer content and the closing of the #main and #page div elements.
 *
 * @package WordPress
 * @subpackage Twenty_Fourteen
 * @since Twenty Fourteen 1.0
 */
?>

	<footer>
		<div class="container">
			<div class="row">
				<div class="col-md-4 footer1">
					<a href="">
						<img src="<?php echo get_template_directory_uri(); ?>/img/logo.png">
					</a>
					<div class="social-icon-wrap">
						<ul class="clearfix">
							<li>
								<a href=""><i class="fa fa-facebook"></i></a>
							</li>
							<li>
								<a href=""><i class="fa fa-twitter"></i></a>
							</li>
							<li>
								<a href=""><i class="fa fa-youtube"></i></a>
							</li>
							<li>
								<a href=""><i class="fa fa-instagram"></i></a>
							</li>
						</ul>
					</div>
				</div>
				<div class="col-md-8 footer2">
					<ul>
						<li>
							<a href="">ABOUT US</a>
						</li>
						<li>
							<a href="">Product</a>
						</li>
						<li>
							<a href="">Company</a>
						</li>
						<li>
							<a href="">Contact</a>
						</li>
					</ul>
					<ul>
						<li>
							<a href="">RESOURCES</a>
						</li>
						<li>
							<a href="">Press</a>
						</li>
						<li>
							<a href="">Career</a>
						</li>
					</ul>
					<ul>
						<li>
							<a href="">LEGAL</a>
						</li>
						<li>
							<a href="">Privacy Policy</a>
						</li>
						<li>
							<a href="">Terms & Conditions</a>
						</li>
						<li>
							<a href="">Sitemap</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<p class="text-center">Compassites. All rights reserved. © 2018</p>
	</footer>
	<script src="https://code.jquery.com/jquery-3.3.1.js" integrity="sha256-2Kok7MbOyxpgUVvAk/HJ2jigOSYS2auK4Pfzbm7uH60=" crossorigin="anonymous"></script>
	<script src="<?php echo get_template_directory_uri(); ?>/js/wow.min.js"></script>
	<script src="<?php echo get_template_directory_uri(); ?>/js/tilt.js"></script>
	<script type="text/javascript">
		new WOW().init();

		$('.js-tilt').tilt({
			maxTilt: 10,
			// reset: false
		});
		// $('.js-tilt-1').tilt({
		//     axis: y
		// });
		$(window).on('load', function(){
			var winH = $(window).height();
			$('.section').height(winH+100);
			$('.section3_container').height(winH/3);
			$('.section3 .background-wrap').height(winH- $('.section3_container').height()+'px');
			$('.section8 .background').height(winH+100);
			// $('.section10').height(winH+100+$('footer').height());
			$('.site-loadingWrap').hide();
		});
		$(document).ready(function() {
			$('.openMenu').click(function(){				
				$('aside').css({"right": "0px"});
				$('.header-menu').hide();
			});
			$('.closeMenu').click(function(){
				$('.header-menu').show();
				$('aside').css({"right": "-1000px"});
			});
			$('.section1 .downArrowBtn i, .getStartedBtn').click(function(){
				$('html, body').animate({ scrollTop: $('.section2_content_wrap').height()+50 }, 1000);
			});	

			$('.connectBtn, .section2_content_wrap .downArrowBtn i ').click(function(){
				$('html, body').animate({ scrollTop: $('.section3_content_wrap').offset().top+50 }, 1000);
			});
			
			$('.flowBtn, .section3_content_wrap .downArrowBtn i').click(function(){
				$('html, body').animate({ scrollTop: $('.section4_content_wrap').offset().top+50}, 1000);
			});
			
			$('.coreBtn, .section4_content_wrap .downArrowBtn i').click(function(){
				$('html, body').animate({ scrollTop: $('.section5_content_wrap').offset().top+50}, 1000);
			});
			
			$('.controlBtn, .section5_content_wrap .downArrowBtn i').click(function(){
				$('html, body').animate({ scrollTop: $('.section6_content_wrap').offset().top+50 }, 1000);
			});
			
			$('.visionBtn, .section6_content_wrap .downArrowBtn i').click(function(){
				$('html, body').animate({ scrollTop: $('.section7_content_wrap').offset().top+50 }, 1000);
			});

			$('.section7_content_wrap .downArrowBtn i').click(function(){
				$('html, body').animate({ scrollTop: $('.section8').offset().top+50 }, 1000);
			});

			$('.section8 .downArrowBtn i').click(function(){
				$('html, body').animate({ scrollTop: $('.section10').offset().top+50 }, 1000);
			});

			// $('.section9 .downArrowBtn i').click(function(){
			// 	$('html, body').animate({ scrollTop: $('.section10').offset().top }, 1000);
			// });
		});
          $('.about-click').on('click', function(){
			$('html, body').animate({ scrollTop: $('.section10').offset().top+50 }, 1000);
			$('.about-click').css({"color" : "#727272"});
			$('.contact-click').css({"color": "#c8cbd2"});
		  })
		  
		  
		  $('.contact-click').on('click', function(){
			$('html, body').animate({ scrollTop: $('.section8').offset().top+50 }, 1000);
			$('.contact-click').css({"color" : "#727272"});
			$('.about-click').css({"color": "#c8cbd2"});
		  })
		  
		$(window).scroll(function(){
			console.log("amir");
			var scrollTop = $(window).scrollTop();
			console.log(scrollTop);
			if (scrollTop > $('.section2_content_wrap').offset().top && scrollTop < $('.section3_content_wrap').offset().top  ) {
				$('.header-login, .header-menu i').css({"color": "#000"});
				$('.logo-wrap img').attr('src', '<?php echo get_template_directory_uri(); ?>/img/logo_blck.png');
			} else if (scrollTop > $('.section5_content_wrap').offset().top && scrollTop < $('.section7_content_wrap').offset().top  ) {
				$('.header-login, .header-menu i').css({"color": "#000"});
				$('.logo-wrap img').attr('src', '<?php echo get_template_directory_uri(); ?>/img/logo_blck.png');
			} else if (scrollTop > $('.section10').offset().top) {
				$('.header-login, .header-menu i').css({"color": "#000"});
				$('.logo-wrap img').attr('src', '<?php echo get_template_directory_uri(); ?>/img/logo_blck.png');
			} else {
				$('.header-login, .header-menu i').css({"color": "#fff"});
				$('.logo-wrap img').attr('src', '<?php echo get_template_directory_uri(); ?>/img/logo_white.png');
			}
		});
		
	</script>
	

	<?php wp_footer(); ?>
</body>
</html>
