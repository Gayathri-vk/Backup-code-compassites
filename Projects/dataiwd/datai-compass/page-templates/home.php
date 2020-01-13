<?php
/**
 * Template Name: Home Page
 *
 * @package WordPress
 * @subpackage Twenty_Fourteen
 * @since Twenty Fourteen 1.0
 */
// Home Page
 $home_page_id=1451;

// Second - 5 Module section
$module_five_tittle_page_id=1452;
$module_five_text_page_id=1453;
$module_five_connect_page_id=1454;
$module_five_flow_page_id=1455;
$module_five_core_page_id=1456;
$module_five_control_page_id=1457;
$module_five_vision_page_id=1458;

// Connect - Section
$connect_discover_page_id=1433;
$connect_share_page_id=1434;
$connect_engage_page_id=1435;

// Flow - Section
$flow_initiate_page_id=1436;
$flow_collaborate_page_id=1437;
$flow_communicate_page_id=1438;

// Core - Section 
$core_structure_page_id=1439;
$core_automate_page_id=1440;
$core_activate_page_id=1441;

// Control 
$control_invoicing_page_id=1445;
$control_risk_page_id=1446;

// vision - Section 
$vision_monitor_page_id=1442;
$vision_insights_page_id=1443;
$vision_trend_page_id=1444;

// About us 
$about_page_id=1447;
$about_what_page_id=1448;
$about_why_page_id=1449;
$about_who_page_id=1450;
get_header(); ?>
	
	<div id="sections">
		<div class="section section_fixed section1">
			<div class="section__clip">
				<div class="section__content">
					<div class="background" style="background: url('<?php echo get_template_directory_uri(); ?>/img/first_image.jpg');"></div>
					<div class="background-content js-tilt" data-wow-duration="2s" data-wow-delay="1s">
						<h3>DATA.<br/> AUTOMATED.<br/> INTELLIGENTLY.</h3>
						<?php
									$home_page = get_post($home_page_id);
						?>
						<p><?php echo $home_page->post_content;?></p>
						<!-- <p>A single, intuitive and comprehensive platform for <br/>advertisers and media agencies to plan, design, execute and <br/>manage the entire media investment process</p> -->
						<button class="getStartedBtn">GET STARTED</button>
					</div>
					<div class="downArrowBtn"><i class="fa fa-angle-down"></i></div>
				</div>
			</div>
		</div>
		<div class="section section_fixed section2_content_wrap">
			<div class="section__clip">
				<div class="section__content">
					<div class="section2_content_piller">
						<div class="">
							<div class="section2_content">
							<?php
									$module_five_title = get_post($module_five_tittle_page_id);
									$module_five_text = get_post($module_five_text_page_id);
									$module_five_connect = get_post($module_five_connect_page_id);
									$module_five_flow = get_post($module_five_flow_page_id);
									$module_five_core = get_post($module_five_core_page_id);
									$module_five_control = get_post($module_five_control_page_id);
									$module_five_vision = get_post($module_five_vision_page_id);
							?>
							<h3 class="text-center"><?php echo $module_five_title->post_content;?></h3>
							<h4 class="text-center"><?php echo $module_five_text->post_content;?></h4>
								<!-- <h3 class="text-center">Unified platform to plan, manage and measure media investment</h3> -->
								<!-- <h4 class="text-center">Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</h4> -->
							</div>
							<div class="et_pb_code_inner clearfix" style="padding-left:35px">
								<div class="col-md-2 col-sm-4 col-xs-12 tile-container">
									<div class="tile-block js-tilt">
										<div class="label-heading">
											<h6>CONNECT</h6>
											<span class="label-icon">
												<img src="<?php echo get_template_directory_uri(); ?>/img/share-1.png">
											</span> 
										</div>
										<p><?php echo $module_five_connect->post_content;?></p>
										<!-- <p>Build your network in media space to share your ideas, interests using DATAI’s social platform. 	</p>-->
											<div class="button-block">
											<button class="connectBtn">Explore</button>
										</div>
									</div> 
								</div>
								<div class="col-md-2 col-sm-4 col-xs-12 tile-container">
									<div class="tile-block js-tilt">
										<div class="label-heading">
											<h6>FLOW</h6>
											<span class="label-icon">
												<img src="<?php echo get_template_directory_uri(); ?>/img/reload.png">
											</span> 
										</div>
										<p><?php echo $module_five_flow->post_content;?></p>
										<!-- <p>Enables the different stakeholders to automate the investment plan, trafficking plan and publish into Ad servers with robust workflow engine.</p> -->
										<div class="button-block">
											<button class="flowBtn">Explore</button>
										</div>
									</div> 
									<img class="arrow-icon" src="<?php echo get_template_directory_uri(); ?>/img/right-arrow.png">
								</div>
								<div class="col-md-2 col-sm-4 col-xs-12 tile-container">
									<div class="tile-block js-tilt">
										<div class="label-heading">
											<h6>CORE</h6>
											<span class="label-icon">
												<img src="<?php echo get_template_directory_uri(); ?>/img/diamond.png">
											</span> 
										</div>
										<p><?php echo $module_five_core->post_content;?></p>
										<!-- <p>Enables to automate the process intelligently by having uniform data structure across all the media channels. </p> -->
										<div class="button-block">
											<button class="coreBtn">Explore</button>
										</div>
									</div> 
									<img class="arrow-icon" src="<?php echo get_template_directory_uri(); ?>/img/right-arrow.png">
								</div>
								<div class="col-md-2 col-sm-4 col-xs-12 tile-container">
									<div class="tile-block js-tilt">
										<div class="label-heading">
											<h6>CONTROL</h6>
											<span class="label-icon">
												<img src="<?php echo get_template_directory_uri(); ?>/img/control.png">
											</span> 
										</div>
										<p><?php echo $module_five_control->post_content;?></p>
										<!-- <p>Automation of invoicing using different pre-defined templates, taxation, servicing fees with precision accuracy. </p> -->
										<div class="button-block">
											<button class="controlBtn">Explore</button>
										</div>
									</div> 
									<img class="arrow-icon" src="<?php echo get_template_directory_uri(); ?>/img/right-arrow.png">
								</div>
								<div class="col-md-2 col-sm-4 col-xs-12 tile-container">
									<div class="tile-block js-tilt">
										<div class="label-heading">
											<h6>VISION</h6>
											<span class="label-icon">
												<img src="<?php echo get_template_directory_uri(); ?>/img/vision.png">
											</span> 
										</div>
										<p><?php echo $module_five_vision->post_content;?></p>
										<!-- <p>Modernized dashboard, intuitive graphical representations of data driven analytical reports which helps to achieve their strategic goals. </p> -->
										<div class="button-block">
											<button class="visionBtn">Explore</button>
										</div>
									</div> 
									<img class="arrow-icon" src="<?php echo get_template_directory_uri(); ?>/img/right-arrow.png">
								</div>
							</div>
							<div class="downArrowBtn"><i class="fa fa-angle-down"></i></div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="section section_fixed section3 section3_content_wrap">
			<div class="section__clip">
				<div class="section__content">
					<div class="background-wrap">
						<div class="background" style="background: url('<?php echo get_template_directory_uri(); ?>/img/background2.jpg');"></div>
						<div class="background-content">
							<h3 class="js-tilt">connect</h3>
						</div>
					</div>
					<?php
							$discover = get_post($connect_discover_page_id);
							$share = get_post($connect_share_page_id);
							$engage = get_post($connect_engage_page_id);
					?>
					<div class="section3_container text-center">
						<div class="row">
							<div class="col-md-4">
								<h3>Discover</h3>
								<p><?php echo $discover->post_content;?></p>
								<!-- <p>Unlock connections in your network and discover new collaboration opportunities</p> -->
							</div>
							<div class="col-md-4">
								<h3>Share</h3>
								<p><?php echo $share->post_content;?></p>
								<!-- <p>Foster your community of industry insiders by sharing your latest news, industry trends, and perspective</p> -->
							</div>
							<div class="col-md-4">
								<h3>Engage</h3>
								<p><?php echo $engage->post_content;?></p>
								<!-- <p>Initiate new connections and help bridge new partners to take your projects to a whole new level</p> -->
							</div>
						</div>
						<div class="downArrowBtn"><i class="fa fa-angle-down"></i></div>
					</div>
				</div>
			</div>
		</div>
		<div class="section section_fixed section5 section4_content_wrap">
			<div class="section__clip">
				<div class="section__content">
					<div class="background" style="background: url('<?php echo get_template_directory_uri(); ?>/img/flow.jpg');"></div>
					<div class="background-content">
						<div class="container">
						<?php
							$initiate = get_post($flow_initiate_page_id);
							$collaborate = get_post($flow_collaborate_page_id);
							$communicate = get_post($flow_communicate_page_id);
						?>
							<div class="section5_container text-center">
								<h2 class="js-tilt">flow</h2>
								<div class="row">
									<div class="col-md-4">
										<h3>INITIATE</h3>
										<p><?php echo $initiate->post_content;?></p>
										<!-- <p>As your starting point, manage all of your investments within a unified workflow with your partners & stakeholders.</p> -->
									</div>
									<div class="col-md-4">
										<h3>COLLABORATE</h3>
										<p><?php echo $collaborate->post_content;?></p>
										<!-- <p>“Working from the same page” takes on a new meaning when you and your partners have access to the real-time status within a unified workflow platform</p> -->
									</div>
									<div class="col-md-4">
										<h3>COMMUNICATE</h3>
										<p><?php echo $communicate->post_content;?></p>
										<!-- <p>Streamline your communications efforts by monitoring the progress of your investment status within one intuitive interface.</p> -->
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="downArrowBtn"><i class="fa fa-angle-down"></i></div>
				</div>			
			</div>
		</div>
		<div class="section section_fixed section6 section5_content_wrap">
			<div class="section__clip">
				<div class="section__content">
					<div class="section6-content">
						<div class="background">
							<div class="container-fluid">
								<div class="row">
									<div class="col-md-8 background_1_wrap">
										<img src="<?php echo get_template_directory_uri(); ?>/img/core1.png">
										<h3>Core</h3>
									</div>
									<div class="col-md-4 background_2_wrap">
										<img class="js-tilt" src="<?php echo get_template_directory_uri(); ?>/img/core2.png">
									</div>
								</div>
							</div>
						</div>
						<?php
							$structure = get_post($core_structure_page_id);
							$automate = get_post($core_automate_page_id);
							$activate = get_post($core_activate_page_id);
						?>
						<div class="content text-center">
							<div class="container">
								<div class="row">
									<div class="col-md-4">
										<h3>STRUCTURE</h3>
										<p><?php echo $structure->post_content;?></p>
										<!-- <p>As your starting point, manage all of your investments within a unified workflow with your partners & stakeholders.</p> -->
									</div>
									<div class="col-md-4">
										<h3>AUTOMATE</h3>
										<p><?php echo $automate->post_content;?></p>
										<!-- <p>“Working from the same page” takes on a new meaning when you and your partners have access to the real-time status within a unified workflow platform</p> -->
									</div>
									<div class="col-md-4">
										<h3>ACTIVATE</h3>
										<p><?php echo $activate->post_content;?></p>
										<!-- <p>Streamline your communications efforts by monitoring the progress of your investment status within one intuitive interface.</p> -->
									</div>
								</div>
							</div>
						</div>
						<div class="downArrowBtn"><i class="fa fa-angle-down"></i></div>
					</div>
				</div>
			</div>
		</div>
		<div class="section section_fixed section7 section6_content_wrap">
			<div class="section__clip">
				<div class="section__content">
					<?php
							$invoicing = get_post($control_invoicing_page_id);
							$risk = get_post($control_risk_page_id);
					?>
					<div class="left-content content">
						<!-- <h3>control</h3> -->
						<!-- <p class="command-para">Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p> -->
						<h3 class="control-heading">control</h3>
						<h4>INVOICING</h4>
						<p><?php echo $invoicing->post_content;?></p>
						<!-- <p class="invoicing-para">Stay on top of your investments each month through the automation of your invoices. DATAI’s AI engine will detect anomalies and flag them for better control of your investmentquat.</p> -->
						
						<h4>RISK</h4>
						<p><?php echo $risk->post_content;?></p>
						<!-- <p class="risk-para">Minimize your investment risk through DATAI’s risk monitoring capabilities. Giving you a peace-of-mind knowing your investments are tracking in the pace that they were intending</p> -->
					</div>
					<div class="right-content content clearfix js-tilt">
						<img src="<?php echo get_template_directory_uri(); ?>/img/command.png" class="pull-right">
					</div>
					<div class="downArrowBtn"><i class="fa fa-angle-down"></i></div>
				</div>
			</div>
		</div>
		<div class="section section_fixed section5 section7_content_wrap">
			<div class="section__clip">
				<div class="section__content">
					<div class="background" style="background: url('<?php echo get_template_directory_uri(); ?>/img/background3.jpg');"></div>
					<div class="background-content">
						<div class="container">
							<div class="section5_container vision-container text-center">
								<h2 class="js-tilt">Vision</h2>
								<?php
										$monitor = get_post($vision_monitor_page_id);
										$insights = get_post($vision_insights_page_id);
										$trend = get_post($vision_trend_page_id)
								?>
								<div class="row vision-subblock">
									<div class="col-md-4">
										<h3>MONITOR</h3>
										<p><?php echo $monitor->post_content;?></p>
										<!-- <p>Keep up-to-date on the progress of each investment within a unified reporting interface. Enabling you to stay informed about the progress of your investments</p> -->
									</div>
									<div class="col-md-4">
										<h3>INSIGHTS</h3>
										<p><?php echo $insights->post_content;?></p>
										<!-- <p>Unlock the potential of your investments through DATAI’s unique visualization. Together with DATAI’s smart structure, discover new dimensions of your investments to help you maximize your ROI.</p> -->
									</div>
									<div class="col-md-4">
										<h3>TREND</h3>
										<p><?php echo $trend->post_content;?></p>
										<!-- <p>Discover trends in your marketplace with DATAI and develop new strategies to make your brand standout from the crowd</p> -->
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="parent-vision-transparent">
						<div class="row vision-transparent"></div>
					</div>
					<div class="downArrowBtn"><i class="fa fa-angle-down"></i></div>
				</div>
			</div>
		</div>
		<div class="section section_fixed section8">
			<div class="section__clip">
				<div class="section__content">
					<div class="background" style="background: url('<?php echo get_template_directory_uri(); ?>/img/background5.jpg');"></div>
					<div class="background-content">
						<div class="container">
							<div class="section8_container text-center">
								<h2 class="js-tilt">contact us</h2>
								<b>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</b>
								<div class="contact-box-wrap js-tilt">
									<h3>Get in touch</h3>
									<p>Lorem ipsum dolor sit amet</p>
								</div>
								<div class="contact-form-wrap">
									<!-- <form>
										<div class="form-group">
											<select name="" class="form-control">
												<option value="0">subject</option>
												<option value="1">General question</option>
												<option value="2">Request a demo</option>
												<option value="3">How to become a reseller</option>
											</select>
										</div>
										<div class="form-group">
											<input type="text" name="" class="form-control" placeholder="First Name">
										</div>
										<div class="form-group">
											<input type="text" name="" class="form-control" placeholder="Last Name">
										</div>
										<div class="form-group">
											<input type="email" name="" class="form-control" placeholder="Email">
										</div>
										<div class="form-group">
											<input type="text" name="" class="form-control" placeholder="Phone">
										</div>
										<div class="form-group">
											<textarea class="form-control" placeholder="Message"></textarea>
										</div>
										<div class="form-group checkbox-wrap clearfix">
											<input type="checkbox" class="form-control"> 
											<label>Follow us on social networks</label>
										</div>
										<div class="form-group">
											<input type="submit" class="btn btn-block">
										</div>
									</form> -->
									<?php echo do_shortcode( '[contact-form-7 id="119" title="Contact form 1"]' );?>
								</div>
							</div>
						</div>
					</div>
					<div class="downArrowBtn"><i class="fa fa-angle-down"></i></div>
				</div>
			</div>
		</div>
		<!-- <div class="section section_fixed section9">
			<div class="section__clip">
				<div class="section__content">
					<div class="background" style="background: url('<?php echo get_template_directory_uri(); ?>/img/background4.jpg');"></div>
					<div class="background-content">
						<div class="container">
							<div class="section9_container text-center">
								<h2 class="js-tilt">resources</h2>
								<span>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</span>
								<div class="row">
									<div class="col-md-3" style="padding:0 20px 0 50px;">
										<i class="fa fa-book js-tilt"></i>
										<h3 class="js-tilt">WHITEPAPER</h3>
										<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
									</div>
									<div class="col-md-3"  style="padding:0 20px 0 50px;">
										<i class="fa fa-desktop js-tilt"></i>
										<h3 class="js-tilt">WEBINARS</h3>
										<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
									</div>
									<div class="col-md-3" style="padding:0 20px 0 50px;">
										<i class="fa fa-bars js-tilt"></i>
										<h3 class="js-tilt">CASES</h3>
										<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
									</div>
									<div class="col-md-3" style="padding:0 20px 0 50px;">
										<i class="fa fa-paperclip js-tilt"></i>
										<h3 class="js-tilt">FAQS</h3>
										<p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p>
									</div>
								</div>
							</div>
						</div>
					</div>
					<div class="downArrowBtn"><i class="fa fa-angle-down"></i></div>
				</div>
			</div>
		</div> -->
		<div class="section section_fixed section10">
			<div class="section__clip">
				<div class="section__content">
					<div class="background-content">
						<div class="container">
							<div class="section10_container text-center">
								<?php
									$about_page = get_post($about_page_id);
									$about_what_page = get_post($about_what_page_id);
									$about_why_page = get_post($about_why_page_id);
									$about_who_page = get_post($about_who_page_id);

								?>
								<h2 class="js-tilt"><?php echo get_the_title('1447');?></h2>
								<span><?php echo $about_page->post_content;?></span>
								<div class="row">
									<div class="col-md-4">
										<img class="js-tilt" src="<?php echo get_template_directory_uri(); ?>/img/image1.png">
										<h3>WHAT WE DO</h3>
										<p><?php echo $about_what_page->post_content;?></p>
										<!-- <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p> -->
									</div>
									<div class="col-md-4">
										<img class="js-tilt" src="<?php echo get_template_directory_uri(); ?>/img/image2.png">
										<h3>WHY IT IS IMPORTANT</h3>
										<p><?php echo $about_why_page->post_content;?></p>
										<!-- <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p> -->
									</div>
									<div class="col-md-4">
										<img class="js-tilt" src="<?php echo get_template_directory_uri(); ?>/img/image3.png">
										<h3>WHO WE ARE</h3>
										<p><?php echo $about_who_page->post_content;?></p>
										<!-- <p>Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.</p> -->
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- <div class="downArrowBtn"><i class="fa fa-angle-down"></i></div> -->
				</div>
			</div>
		</div>
	</div>

<?php
get_footer();