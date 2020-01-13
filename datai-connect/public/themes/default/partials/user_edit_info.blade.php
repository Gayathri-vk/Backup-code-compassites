<div class="user-profile-details">
@if($timeline->id == Auth::user()->timeline_id)

                    <a href="{{ url('/'.Auth::user()->username.'/settings/general') }}" class="editMyProfileBtn"><i class="fa fa-pencil-square-o user-detail-icon edit-icon col-md-2 col-sm-2 col-xs-2" aria-hidden="true"></i>Edit Profile</a>
                    @endif

@if(Auth::user()->username != $timeline->username)
<div class="profileBtns">
        <?php 
                    //php code is for checking user's follow_privacy settings
        $user_follow ="";
        $confirm_follow ="";
        $message_privacy ="";                       
        $othersSettings = $user->getOthersSettings($timeline->username);
        if($othersSettings)
        {
                        //follow_privacy checking
            if ($othersSettings->follow_privacy == "only_follow") {
                $user_follow = "only_follow";
            }elseif ($othersSettings->follow_privacy == "everyone") {
                $user_follow = "everyone";
            }

                        //confirm_follow checking
            if ($othersSettings->confirm_follow == "yes") {
                $confirm_follow = "yes";
            }elseif ($othersSettings->confirm_follow == "no") {
                $confirm_follow = "no";
            }

            //message_privacy checking
            if ($othersSettings->message_privacy == "only_follow") {
                $message_privacy = "only_follow";
            }elseif ($othersSettings->message_privacy == "everyone") {
                $message_privacy = "everyone";
            }
        }

        ?>

        <!-- This [if-2] is for checking usersettings follow_privacy showing follow/following || message button -->
        @if($confirm_follow == "no")

            <!-- This [if-3] is for checking usersettings follow_privacy showing follow/following || message button -->
            @if(($user->followers->contains(Auth::user()->id) && $user_follow == "only_follow") || ($user_follow == "everyone"))

                @if(!$user->followers->contains(Auth::user()->id))
                    
                    @if($message_privacy == "everyone")
                        <div class="col-md-6 col-sm-6 col-xs-6 left-col">
                            <a href="#" class="btn btn-options btn-block follow-user btn-default follow" data-timeline-id="{{ $timeline->id }}">
                                <i class="fa fa-user-plus"></i> {{ trans('common.follow') }}
                            </a>
                        </div>
                    @else
                        <div class="col-md-12 col-sm-6 col-xs-6">
                            <a href="#" class="btn btn-options btn-block follow-user btn-default follow" data-timeline-id="{{ $timeline->id }}">
                                <i class="fa fa-user-plus"></i> {{ trans('common.follow') }}
                            </a>
                        </div>
                    @endif  
                    
                    @if($message_privacy == "everyone")
                        <div class="col-md-6 col-sm-6 col-xs-6 hidden">
                            <a href="#" class="btn btn-options btn-block follow-user btn-success unfollow" data-timeline-id="{{ $timeline->id }}">
                                <i class="fa fa-check"></i> {{ trans('common.following') }}
                            </a>
                        </div>
                    @else
                        <div class="col-md-12 col-sm-6 col-xs-6 hidden">
                            <a href="#" class="btn btn-options btn-block follow-user btn-success unfollow" data-timeline-id="{{ $timeline->id }}">
                                <i class="fa fa-check"></i> {{ trans('common.following') }}
                            </a>
                        </div>
                    @endif  
                @else

                    <div class="col-md-6 col-sm-6 col-xs-6 hidden">
                        <a href="#" class="btn btn-options btn-block follow-user btn-default follow " data-timeline-id="{{ $timeline->id }}">
                            <i class="fa fa-user-plus"></i> {{ trans('common.follow') }}
                        </a>
                    </div>

                    <div class="col-md-6 col-sm-6 col-xs-6 left-col">
                        <a href="#" class="btn btn-options btn-block follow-user btn-success unfollow" data-timeline-id="{{ $timeline->id }}">  <i class="fa fa-check"></i> {{ trans('common.following') }}
                        </a>
                    </div>
                @endif
            @elseif(($user->following->contains(Auth::user()->id) && $user_follow == "only_follow") || ($user_follow == "everyone"))

                @if(!$user->followers->contains(Auth::user()->id))
                    @if($message_privacy == "everyone") 
                        <div class="col-md-6 col-sm-6 col-xs-6 left-col">
                            <a href="#" class="btn btn-options btn-block follow-user btn-default follow" data-timeline-id="{{ $timeline->id }}">
                                <i class="fa fa-user-plus"></i> {{ trans('common.follow') }}
                            </a>
                        </div>
                    @else
                        <div class="col-md-12 col-sm-6 col-xs-6 left-col">
                        <a href="#" class="btn btn-options btn-block follow-user btn-default follow" data-timeline-id="{{ $timeline->id }}">
                            <i class="fa fa-user-plus"></i> {{ trans('common.follow') }}
                        </a>
                    </div>
                    @endif
                    
                    @if($message_privacy == "everyone")
                        <div class="col-md-6 col-sm-6 col-xs-6 hidden">
                            <a href="#" class="btn btn-options btn-block follow-user btn-success unfollow" data-timeline-id="{{ $timeline->id }}">
                                <i class="fa fa-check"></i> {{ trans('common.following') }}
                            </a>
                        </div>
                    @else
                        <div class="col-md-12 col-sm-6 col-xs-6 hidden">
                            <a href="#" class="btn btn-options btn-block follow-user btn-success unfollow" data-timeline-id="{{ $timeline->id }}">
                                <i class="fa fa-check"></i> {{ trans('common.following') }}
                            </a>
                        </div>
                    @endif

                @else                           
                    <div class="col-md-6 col-sm-6 col-xs-6 hidden">
                        <a href="#" class="btn btn-options btn-block follow-user btn-default follow " data-timeline-id="{{ $timeline->id }}">
                            <i class="fa fa-user-plus"></i> {{ trans('common.follow') }}
                        </a>
                    </div>

                    <div class="col-md-6 col-sm-6 col-xs-6 left-col">
                        <a href="#" class="btn btn-options btn-block follow-user btn-success unfollow" data-timeline-id="{{ $timeline->id }}">  <i class="fa fa-user-plus"></i> {{ trans('common.following') }}
                        </a>
                    </div>
                @endif
            @endif  <!-- End of [if-3]-->
 
            @elseif($confirm_follow == "yes")

            <!-- This [if-4] is for checking usersettings follow_privacy showing follow/following || message button -->
                @if(($user->followers->contains(Auth::user()->id) && $user_follow == "only_follow") || ($user_follow == "everyone"))

                    @if(!$user->followers->contains(Auth::user()->id))

                        @if($message_privacy == "everyone")

                            <div class="col-md-6 col-sm-6 col-xs-6 left-col">
                                <a href="#" class="btn btn-options btn-block btn-default follow-user-confirm follow" data-timeline-id="{{ $timeline->id }}-{{ $follow_user_status }}">
                                    <i class="fa fa-user-plus"></i> {{ trans('common.follow') }}
                                </a>
                            </div>

                        @else
                            <div class="col-md-12 col-sm-6 col-xs-6">
                                <a href="#" class="btn btn-options btn-block btn-default follow-user-confirm follow" data-timeline-id="{{ $timeline->id }}-{{ $follow_user_status }}">
                                    <i class="fa fa-user-plus"></i> {{ trans('common.follow') }}
                                </a>
                            </div>
                        @endif
                        
                        @if($message_privacy == "everyone")
                            <div class="col-md-6 col-sm-6 col-xs-6 hidden">
                                <a href="#" class="btn btn-options btn-block follow-user-confirm btn-warning followrequest" data-timeline-id="{{ $timeline->id }}-{{ $follow_user_status }}">
                                    <i class="fa fa-check"></i> {{ trans('common.requested') }}
                                </a>
                            </div>
                        @else
                            <div class="col-md-12 col-sm-6 col-xs-6 hidden">
                                <a href="#" class="btn btn-options btn-block follow-user-confirm btn-warning followrequest" data-timeline-id="{{ $timeline->id }}-{{ $follow_user_status }}">
                                    <i class="fa fa-check"></i> {{ trans('common.requested') }}
                                </a>
                            </div>
                        @endif  
                    @else
                        <div class="col-md-6 col-sm-6 col-xs-6 hidden">
                            <a href="#" class="btn btn-options btn-block btn-default follow-user-confirm  follow " data-timeline-id="{{ $timeline->id }}-{{ $follow_user_status }}">
                                <i class="fa fa-user-plus"></i> {{ trans('common.follow') }}
                            </a>
                        </div>

                    @if($follow_user_status == "pending")
                    <div class="col-md-6 col-sm-6 col-xs-6 left-col">
                        <a href="#" class="btn btn-options btn-block follow-user-confirm btn-warning followrequest" data-timeline-id="{{ $timeline->id }}-{{ $follow_user_status }}">
                            <i class="fa fa-check"></i> {{ trans('common.requested') }}
                        </a>
                    </div>
                    @endif
                    @if($follow_user_status == "approved")
                    <div class="col-md-6 col-sm-6 col-xs-6 left-col">
                        <a href="#" class="btn btn-options btn-block follow-user-confirm btn-primary unfollow" data-timeline-id="{{ $timeline->id }}-{{ $follow_user_status }}">
                            <i class="fa fa-check"></i> {{ trans('common.following') }}
                        </a>
                    </div>
                    @endif
                @endif
            @endif  <!-- End of [if-4]-->
        @endif  <!-- End of [if-2]-->
            @if(($user->followers->contains(Auth::user()->id) && $message_privacy == "only_follow") || ($message_privacy == "everyone"))    
                <div class="col-md-6 col-sm-6 col-xs-6 right-col">
                    <a href="#" class="btn btn-options btn-block btn-default" onClick="chatBoxes.sendMessage({{ $timeline->user->id }})">
                        <i class="fa fa-inbox"></i> {{ trans('common.message') }}
                    </a>
                </div>
            @endif
            </div>
        @endif <!-- End of [if-1]-->


                    
                    <div class="user-name row">
                        <div>
                        <i class="fa fa-user user-detail-icon col-md-2 col-sm-2 col-xs-2" aria-hidden="true"></i>
                        </div>
                        <div class="user-name-title user-details col-md-7 col-sm-7 col-xs-7">{{ $timeline->name }}<span>Name</span>
                        </div>
                       </div>
                    <div class="contact-number row">
                        <div>
                        <i class="fa fa-phone user-detail-icon col-md-2 col-sm-2 col-xs-2" aria-hidden="true"></i>
                       </div>
                        <div class="contact-number-title user-details col-md-7 col-sm-7 col-xs-7">00-00000(00)<span>Contact Number</span>
                        </div>
                    </div>
                    </div>
                    <div class="manging-director row">
                        <div>
                        <i class="fa fa-building-o user-detail-icon col-md-2 col-sm-2 col-xs-2" aria-hidden="true"></i>
                        </div>
                        <div class="managing-director-title user-details col-md-7 col-sm-7 col-xs-7">Manging director,XYZ Pvt Ltd
                        </div>
                    </div>


                <div class="user-avatar-progress hidden">
                </div>
            </div>


    <div class="about">
                <div class="about-title row">
                    <span class="managing-director-title col-md-6 col-sm-6 col-xs-6">About
                    </span>
                </div>
                <p class="about-description">Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus.</p>
                <!-- <span class="read-more">Read More</span> -->
            </div>