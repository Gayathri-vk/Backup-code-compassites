-- phpMyAdmin SQL Dump
-- version 4.8.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost
-- Generation Time: Oct 27, 2018 at 06:40 AM
-- Server version: 5.7.22-0ubuntu18.04.1
-- PHP Version: 7.2.5-1+ubuntu18.04.1+deb.sury.org+1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET AUTOCOMMIT = 0;
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `urloop-new`
--

-- --------------------------------------------------------

--
-- Table structure for table `albums`
--

CREATE TABLE `albums` (
  `id` int(10) UNSIGNED NOT NULL,
  `timeline_id` int(10) UNSIGNED NOT NULL,
  `name` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `slug` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `about` text COLLATE utf8_unicode_ci NOT NULL,
  `preview_id` int(10) UNSIGNED DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `privacy` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `album_media`
--

CREATE TABLE `album_media` (
  `id` int(10) UNSIGNED NOT NULL,
  `album_id` int(10) UNSIGNED NOT NULL,
  `media_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `image` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `start_date` date NOT NULL,
  `end_date` date NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `announcement_user`
--

CREATE TABLE `announcement_user` (
  `id` int(10) UNSIGNED NOT NULL,
  `announcement_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE `categories` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `active` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `name`, `description`, `parent_id`, `active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'Airport', 'description about Airport', 1, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(2, 'Automotive', 'description about Automotive', 2, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(3, 'Bank/Financial Services', 'description about Bank/Financial Services', 3, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(4, 'Bar', 'description about Bar', 4, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(5, 'Book Store', 'description about Book Store', 5, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(6, 'Business Services', 'description about Business Services', 6, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(7, 'Church/Religious Organization', 'description about Church/Religious Organization', 7, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(8, 'Club', 'description about Club', 8, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(9, 'Concert Venue', 'description about Concert Venue', 9, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(10, 'Doctor', 'description about Doctor', 10, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(11, 'Education', 'description about Education', 11, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(12, 'Event Planning/Event Services', 'description about Event Planning/Event Services', 12, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(13, 'Home Improvement', 'description about Home Improvement', 13, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(14, 'Hotel', 'description about Hotel', 14, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(15, 'Landmark', 'description about Landmark', 15, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(16, 'category1', 'description about category1', 16, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(17, 'category2', 'description about category2', 17, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(18, 'category3', 'description about category3', 18, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(19, 'category4', 'description about category4', 19, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(20, 'category5', 'description about category5', 20, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(21, 'category6', 'description about category6', 21, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(22, 'category7', 'description about category7', 22, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(23, 'category8', 'description about category8', 23, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(24, 'category9', 'description about category9', 24, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(25, 'category10', 'description about category10', 25, 1, '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `comments`
--

CREATE TABLE `comments` (
  `id` int(10) UNSIGNED NOT NULL,
  `post_id` int(10) UNSIGNED NOT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `media_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `comments`
--

INSERT INTO `comments` (`id`, `post_id`, `description`, `user_id`, `parent_id`, `created_at`, `updated_at`, `deleted_at`, `media_id`) VALUES
(1, 10, 'nyc', 2, NULL, '2018-10-26 05:45:10', '2018-10-26 05:45:10', NULL, NULL),
(2, 14, 'gud', 2, NULL, '2018-10-26 17:13:46', '2018-10-26 17:13:46', NULL, NULL),
(4, 12, 'hai', 2, NULL, '2018-10-26 17:47:58', '2018-10-26 17:47:58', NULL, NULL),
(5, 12, 'hau', 2, NULL, '2018-10-26 17:49:36', '2018-10-26 17:49:36', NULL, NULL),
(6, 12, 'hau', 2, NULL, '2018-10-26 17:49:40', '2018-10-26 17:49:40', NULL, NULL),
(7, 12, 'hai', 2, NULL, '2018-10-26 17:49:52', '2018-10-26 17:49:52', NULL, NULL),
(8, 12, 'hai', 2, NULL, '2018-10-26 17:50:54', '2018-10-26 17:50:54', NULL, NULL),
(11, 6, 'hi', 2, NULL, '2018-10-26 17:59:23', '2018-10-26 17:59:23', NULL, NULL),
(12, 13, 'hi', 2, NULL, '2018-10-26 18:00:43', '2018-10-26 18:00:43', NULL, NULL),
(14, 9, 'hai', 2, NULL, '2018-10-26 18:10:27', '2018-10-26 18:10:27', NULL, NULL),
(15, 8, 'hi', 2, NULL, '2018-10-26 18:11:06', '2018-10-26 18:11:06', NULL, NULL),
(16, 7, 'g', 2, NULL, '2018-10-26 18:11:54', '2018-10-26 18:11:54', NULL, NULL),
(17, 7, 'h', 2, NULL, '2018-10-26 18:12:02', '2018-10-26 18:12:02', NULL, NULL),
(18, 7, 'hi', 2, NULL, '2018-10-26 18:13:06', '2018-10-26 18:13:06', NULL, NULL),
(20, 11, 'haii', 2, NULL, '2018-10-26 18:14:47', '2018-10-26 18:14:47', NULL, NULL),
(21, 10, 'haai', 2, NULL, '2018-10-26 18:16:19', '2018-10-26 18:16:19', NULL, NULL),
(22, 4, 'hi,How are u?', 2, NULL, '2018-10-26 18:32:48', '2018-10-26 18:32:48', NULL, NULL),
(23, 7, 'santhosh', 2, NULL, '2018-10-26 18:33:46', '2018-10-26 18:33:46', NULL, NULL),
(24, 6, 'sasa', 2, NULL, '2018-10-26 18:35:15', '2018-10-26 18:35:15', NULL, NULL),
(25, 16, 'hi', 3, NULL, '2018-10-26 18:56:11', '2018-10-26 18:56:11', NULL, NULL),
(26, 16, 'hai', 3, NULL, '2018-10-26 19:00:19', '2018-10-26 19:00:19', NULL, NULL),
(27, 16, 'hai', 2, NULL, '2018-10-26 20:02:28', '2018-10-26 20:02:28', NULL, NULL),
(28, 16, 'hai', 2, NULL, '2018-10-26 20:02:33', '2018-10-26 20:02:33', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `comment_likes`
--

CREATE TABLE `comment_likes` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `comment_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `events`
--

CREATE TABLE `events` (
  `id` int(10) UNSIGNED NOT NULL,
  `timeline_id` int(10) UNSIGNED NOT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `location` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `invite_privacy` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `timeline_post_privacy` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `group_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `event_user`
--

CREATE TABLE `event_user` (
  `id` int(10) UNSIGNED NOT NULL,
  `event_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `followers`
--

CREATE TABLE `followers` (
  `id` int(10) UNSIGNED NOT NULL,
  `follower_id` int(10) UNSIGNED NOT NULL,
  `leader_id` int(10) UNSIGNED NOT NULL,
  `status` varchar(50) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `followers`
--

INSERT INTO `followers` (`id`, `follower_id`, `leader_id`, `status`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 2, 3, 'approved', NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `groups`
--

CREATE TABLE `groups` (
  `id` int(10) UNSIGNED NOT NULL,
  `timeline_id` int(10) UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `type` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `member_privacy` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `post_privacy` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `event_privacy` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `group_user`
--

CREATE TABLE `group_user` (
  `id` int(10) UNSIGNED NOT NULL,
  `group_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `status` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `hashtags`
--

CREATE TABLE `hashtags` (
  `id` int(10) UNSIGNED NOT NULL,
  `tag` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `last_trend_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `count` bigint(20) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `languages`
--

CREATE TABLE `languages` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `media`
--

CREATE TABLE `media` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `type` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `source` varchar(500) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `media`
--

INSERT INTO `media` (`id`, `title`, `type`, `source`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, '2018-10-26-17-52-55Good-morning-wish-on-image-with-pink-flower.jpg', 'image', '2018-10-26-17-52-55Good-morning-wish-on-image-with-pink-flower.jpg', '2018-10-26 17:52:55', '2018-10-26 17:52:55', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(10) UNSIGNED NOT NULL,
  `thread_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `body` text COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` datetime DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `migrations`
--

CREATE TABLE `migrations` (
  `id` int(10) UNSIGNED NOT NULL,
  `migration` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `batch` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_100000_create_password_resets_table', 1),
(2, '2014_10_12_100000_create_settings_table', 1),
(3, '2014_10_28_175635_create_threads_table', 1),
(4, '2014_10_28_175710_create_messages_table', 1),
(5, '2014_10_28_180224_create_participants_table', 1),
(6, '2014_11_03_154831_add_soft_deletes_to_participants_table', 1),
(7, '2014_11_10_083449_add_nullable_to_last_read_in_participants_table', 1),
(8, '2014_11_20_131739_alter_last_read_in_participants_table', 1),
(9, '2014_12_04_124531_add_softdeletes_to_threads_table', 1),
(10, '2016_05_11_102459_create_categories_table', 1),
(11, '2016_05_11_102459_create_followers_table', 1),
(12, '2016_05_11_102459_create_group_user_table', 1),
(13, '2016_05_11_102459_create_groups_table', 1),
(14, '2016_05_11_102459_create_languages_table', 1),
(15, '2016_05_11_102459_create_media_table', 1),
(16, '2016_05_11_102459_create_page_likes_table', 1),
(17, '2016_05_11_102459_create_page_user_table', 1),
(18, '2016_05_11_102459_create_pages_table', 1),
(19, '2016_05_11_102459_create_post_follows_table', 1),
(20, '2016_05_11_102459_create_post_likes_table', 1),
(21, '2016_05_11_102459_create_post_media_table', 1),
(22, '2016_05_11_102459_create_post_shares_table', 1),
(23, '2016_05_11_102459_create_posts_table', 1),
(24, '2016_05_11_102459_create_timelines_table', 1),
(25, '2016_05_11_102459_create_user_settings_table', 1),
(26, '2016_05_11_102459_create_users_table', 1),
(27, '2016_05_11_102460_create_timeline_reports_table', 1),
(28, '2016_05_11_102500_create_announcement_user_table', 1),
(29, '2016_05_11_102500_create_announcements_table', 1),
(30, '2016_05_11_102500_create_comment_likes_table', 1),
(31, '2016_05_11_102500_create_comments_table', 1),
(32, '2016_05_11_102500_create_hashtags_table', 1),
(33, '2016_05_11_102500_create_notifications_table', 1),
(34, '2016_05_11_102500_create_post_reports_table', 1),
(35, '2016_07_08_170940_create_post_tags_table', 1),
(36, '2016_08_01_123157_entrust_setup_tables', 1),
(37, '2016_08_02_123157_create_foreign_keys', 1),
(38, '2016_08_03_103604_create_static_pages_table', 1),
(39, '2016_08_28_194209_alter_users', 1),
(40, '2016_08_31_174439_insert_settings', 1),
(41, '2016_09_04_022020_database_update_one_dot_two', 1),
(42, '2016_09_05_224813_database_update_one_dot_three', 1),
(43, '2016_10_24_070240_database_update_one_dot_four', 1),
(44, '2016_11_12_064152_database_update_two_dot_one', 1),
(45, '2017_02_26_074925_create_sessions_table', 1),
(46, '2017_03_01_135034_database_update_two_dot_two', 1),
(47, '2017_05_18_035912_create_wallpapers', 1),
(48, '2017_05_18_051905_database_update_three', 1),
(49, '2017_05_25_085951_alter_messages_table', 1),
(50, '2017_07_10_114459_create_saved_timelines_table', 1),
(51, '2017_07_10_124410_create_saved_posts_table', 1);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(10) UNSIGNED NOT NULL,
  `post_id` int(10) UNSIGNED DEFAULT NULL,
  `timeline_id` int(10) UNSIGNED DEFAULT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `notified_by` int(10) UNSIGNED NOT NULL,
  `seen` tinyint(1) NOT NULL DEFAULT '0',
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `type` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `link` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `post_id`, `timeline_id`, `user_id`, `notified_by`, `seen`, `description`, `type`, `link`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, NULL, 3, 3, 2, 0, 'gayathri is following you', 'follow', NULL, '2018-10-26 17:06:55', '2018-10-26 17:06:55', NULL),
(2, 14, NULL, 3, 2, 0, 'gayathri commented on your post', 'comment_post', NULL, '2018-10-26 17:13:46', '2018-10-26 17:13:46', NULL),
(3, 12, NULL, 3, 2, 0, 'gayathri commented on your post', 'comment_post', NULL, '2018-10-26 17:47:58', '2018-10-26 17:47:58', NULL),
(4, 12, NULL, 3, 2, 0, 'gayathri commented on your post', 'comment_post', NULL, '2018-10-26 17:49:36', '2018-10-26 17:49:36', NULL),
(5, 12, NULL, 3, 2, 0, 'gayathri commented on your post', 'comment_post', NULL, '2018-10-26 17:49:40', '2018-10-26 17:49:40', NULL),
(6, 12, NULL, 3, 2, 0, 'gayathri commented on your post', 'comment_post', NULL, '2018-10-26 17:49:52', '2018-10-26 17:49:52', NULL),
(7, 12, NULL, 3, 2, 0, 'gayathri commented on your post', 'comment_post', NULL, '2018-10-26 17:50:54', '2018-10-26 17:50:54', NULL),
(8, 13, NULL, 3, 2, 0, 'gayathri commented on your post', 'comment_post', NULL, '2018-10-26 18:00:44', '2018-10-26 18:00:44', NULL),
(9, 16, NULL, 3, 2, 0, 'gayathri commented on your post', 'comment_post', NULL, '2018-10-26 20:02:28', '2018-10-26 20:02:28', NULL),
(10, 16, NULL, 3, 2, 0, 'gayathri commented on your post', 'comment_post', NULL, '2018-10-26 20:02:33', '2018-10-26 20:02:33', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `pages`
--

CREATE TABLE `pages` (
  `id` int(10) UNSIGNED NOT NULL,
  `timeline_id` int(10) UNSIGNED NOT NULL,
  `address` text COLLATE utf8_unicode_ci,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `category_id` int(10) UNSIGNED NOT NULL,
  `message_privacy` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `member_privacy` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `phone` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `timeline_post_privacy` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `website` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `page_likes`
--

CREATE TABLE `page_likes` (
  `id` int(10) UNSIGNED NOT NULL,
  `page_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `page_user`
--

CREATE TABLE `page_user` (
  `id` int(10) UNSIGNED NOT NULL,
  `page_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `participants`
--

CREATE TABLE `participants` (
  `id` int(10) UNSIGNED NOT NULL,
  `thread_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `last_read` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `password_resets`
--

CREATE TABLE `password_resets` (
  `email` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `token` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permissions`
--

CREATE TABLE `permissions` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `display_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `permission_role`
--

CREATE TABLE `permission_role` (
  `permission_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `posts`
--

CREATE TABLE `posts` (
  `id` int(10) UNSIGNED NOT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `timeline_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `soundcloud_title` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `soundcloud_id` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `youtube_title` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `youtube_video_id` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `location` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL,
  `shared_post_id` int(10) UNSIGNED DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `posts`
--

INSERT INTO `posts` (`id`, `description`, `timeline_id`, `user_id`, `active`, `soundcloud_title`, `soundcloud_id`, `youtube_title`, `youtube_video_id`, `location`, `type`, `created_at`, `updated_at`, `deleted_at`, `shared_post_id`) VALUES
(1, 'ggrw', 1, 1, 1, '', '', '', '', '', NULL, '2018-10-25 09:06:41', '2018-10-25 09:06:41', NULL, NULL),
(2, 'jutit', 2, 2, 1, '', '', '', '', '', NULL, '2018-10-25 13:01:40', '2018-10-25 13:01:40', NULL, NULL),
(3, 'hai good evening', 2, 2, 1, '', '', '', '', '', NULL, '2018-10-25 13:09:21', '2018-10-25 13:09:21', NULL, NULL),
(4, 'Hey Cindi, you should really check out this new song by Iron Maid. The next time they come to the city we should totally go!', 2, 2, 1, '', '', '', '', '', NULL, '2018-10-26 05:08:33', '2018-10-26 05:08:33', NULL, NULL),
(5, 'Hey Cindi, you should really check out this new song by Iron Maid. The next time they come to the city we should totally go!', 2, 2, 1, '', '', '', '', '', NULL, '2018-10-26 05:09:30', '2018-10-26 05:09:30', NULL, NULL),
(6, 'Hey Cindi, you should really check out this new song by Iron Maid. The next time they come to the city we should totally go!', 2, 2, 1, '', '', '', '', '', NULL, '2018-10-26 05:10:08', '2018-10-26 05:10:08', NULL, NULL),
(7, 'Hey Cindi, you should really check out this new song by Iron Maid. The next time they come to the city we should totally go!', 2, 2, 1, '', '', '', '', '', NULL, '2018-10-26 05:13:17', '2018-10-26 05:13:17', NULL, NULL),
(8, 'Hey Cindi, you should really check out this new song by Iron Maid. The next time they come to the city we should totally go!', 2, 2, 1, '', '', '', '', '', NULL, '2018-10-26 05:14:00', '2018-10-26 05:14:00', NULL, NULL),
(9, 'hai', 2, 2, 1, '', '', '', '', '', NULL, '2018-10-26 05:17:22', '2018-10-26 05:17:22', NULL, NULL),
(10, 'BROADCAST_DRIVER=pusher \r\nPUSHER_APP_ID=554163 \r\nPUSHER_APP_KEY=a98fe369850f5c196cda \r\nPUSHER_APP_SECRET=97945b3891df67fdbe6f \r\nPUSHER_APP_CLUSTER=mt1', 2, 2, 1, '', '', '', '', '', NULL, '2018-10-26 05:25:35', '2018-10-26 05:25:35', NULL, NULL),
(11, 'hello\n\n', 2, 2, 1, '', '', '', '', '', NULL, '2018-10-26 16:28:26', '2018-10-26 16:28:26', NULL, NULL),
(12, 'Test post!!!', 3, 3, 1, '', '', '', '', '', NULL, '2018-10-26 17:06:38', '2018-10-26 17:06:38', NULL, NULL),
(13, 'Good', 3, 3, 1, '', '', '', '', '', NULL, '2018-10-26 17:06:45', '2018-10-26 17:06:45', NULL, NULL),
(14, 'Nice', 3, 3, 1, '', '', '', '', '', NULL, '2018-10-26 17:06:50', '2018-10-26 17:06:50', NULL, NULL),
(15, '', 2, 2, 1, '', '', '', '', '', NULL, '2018-10-26 17:52:55', '2018-10-26 17:52:55', NULL, NULL),
(16, 'post', 3, 3, 1, '', '', '', '', '', NULL, '2018-10-26 18:55:58', '2018-10-26 18:55:58', NULL, NULL),
(17, '', 2, 2, 1, '', '', '', '', 'Kerala, India', NULL, '2018-10-26 20:37:26', '2018-10-26 20:37:26', NULL, NULL),
(18, '', 2, 2, 1, '', '', '', '', 'Karnataka, India', NULL, '2018-10-26 20:45:54', '2018-10-26 20:45:54', NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `post_follows`
--

CREATE TABLE `post_follows` (
  `id` int(10) UNSIGNED NOT NULL,
  `post_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `post_follows`
--

INSERT INTO `post_follows` (`id`, `post_id`, `user_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 1, NULL, NULL, NULL),
(2, 2, 2, NULL, NULL, NULL),
(3, 3, 2, NULL, NULL, NULL),
(4, 4, 2, NULL, NULL, NULL),
(5, 5, 2, NULL, NULL, NULL),
(6, 6, 2, NULL, NULL, NULL),
(8, 8, 2, NULL, NULL, NULL),
(20, 6, 2, NULL, NULL, NULL),
(22, 12, 3, NULL, NULL, NULL),
(23, 13, 3, NULL, NULL, NULL),
(25, 15, 2, NULL, NULL, NULL),
(26, 16, 3, NULL, NULL, NULL),
(27, 14, 3, NULL, NULL, NULL),
(29, 18, 2, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `post_likes`
--

CREATE TABLE `post_likes` (
  `id` int(10) UNSIGNED NOT NULL,
  `post_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `post_likes`
--

INSERT INTO `post_likes` (`id`, `post_id`, `user_id`, `created_at`, `updated_at`) VALUES
(3, 6, 2, '2018-10-26 16:48:04', '2018-10-26 16:48:04');

-- --------------------------------------------------------

--
-- Table structure for table `post_media`
--

CREATE TABLE `post_media` (
  `id` int(10) UNSIGNED NOT NULL,
  `post_id` int(10) UNSIGNED NOT NULL,
  `media_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `post_media`
--

INSERT INTO `post_media` (`id`, `post_id`, `media_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 15, 1, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `post_reports`
--

CREATE TABLE `post_reports` (
  `id` int(10) UNSIGNED NOT NULL,
  `post_id` int(10) UNSIGNED NOT NULL,
  `reporter_id` int(10) UNSIGNED NOT NULL,
  `status` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `post_shares`
--

CREATE TABLE `post_shares` (
  `id` int(10) UNSIGNED NOT NULL,
  `post_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `post_tags`
--

CREATE TABLE `post_tags` (
  `id` int(10) UNSIGNED NOT NULL,
  `post_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `roles`
--

CREATE TABLE `roles` (
  `id` int(10) UNSIGNED NOT NULL,
  `name` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `display_name` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `description` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `roles`
--

INSERT INTO `roles` (`id`, `name`, `display_name`, `description`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'admin', 'Admin', 'Access to everything', '2018-10-25 09:05:37', '2018-10-25 09:05:37', NULL),
(2, 'user', 'User', 'Access limited to user', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(3, 'moderator', 'Moderator', 'Access limited to moderator', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(4, 'editor', 'Editor', 'Access limited to editor', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `role_user`
--

CREATE TABLE `role_user` (
  `user_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `role_user`
--

INSERT INTO `role_user` (`user_id`, `role_id`) VALUES
(1, 1);

-- --------------------------------------------------------

--
-- Table structure for table `saved_posts`
--

CREATE TABLE `saved_posts` (
  `id` int(10) UNSIGNED NOT NULL,
  `post_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `saved_timelines`
--

CREATE TABLE `saved_timelines` (
  `id` int(10) UNSIGNED NOT NULL,
  `timeline_id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `type` varchar(100) COLLATE utf8_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `sessions`
--

CREATE TABLE `sessions` (
  `id` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `ip_address` varchar(45) COLLATE utf8_unicode_ci DEFAULT NULL,
  `user_agent` text COLLATE utf8_unicode_ci,
  `payload` text COLLATE utf8_unicode_ci NOT NULL,
  `last_activity` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `settings`
--

CREATE TABLE `settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `key` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `value` text COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `settings`
--

INSERT INTO `settings` (`id`, `key`, `value`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'noreply_email', 'noreply@socialite.com', '2018-10-25 09:05:22', '2018-10-25 09:05:22', NULL),
(2, 'language', 'en', '2018-10-25 09:05:22', '2018-10-25 09:05:22', NULL),
(3, 'logo', 'logo.jpg', '2018-10-25 09:05:22', '2018-10-25 09:05:22', NULL),
(4, 'favicon', 'favicon.jpg', '2018-10-25 09:05:22', '2018-10-25 09:05:22', NULL),
(5, 'enable_browse', 'on', '2018-10-25 09:05:22', '2018-10-25 09:05:22', NULL),
(6, 'meta_description', 'Socialite is the FIRST Social networking script developed on Laravel with all enhanced features, Pixel perfect design and extremely user friendly. User interface and user experience are extra added features to Socialite. Months of research, passion and hard work had made the Socialite more flexible, feature-available and very user friendly!', '2018-10-25 09:05:22', '2018-10-25 09:05:22', NULL),
(7, 'meta_keywords', 'facebook clone, laravel, live chat, message, news feed, php social network, php social platform, php socialite, post, social, social network, social networking, social platform, social script, socialite', '2018-10-25 09:05:22', '2018-10-25 09:05:22', NULL),
(8, 'site_tagline', 'Laravel social network script', '2018-10-25 09:05:22', '2018-10-25 09:05:22', NULL),
(9, 'invite_privacy', 'only_admins', '2018-10-25 09:05:24', '2018-10-25 09:05:24', NULL),
(10, 'event_timeline_post_privacy', 'only_guests', '2018-10-25 09:05:24', '2018-10-25 09:05:24', NULL),
(11, 'title_seperator', '|', '2018-10-25 09:05:24', '2018-10-25 09:05:24', NULL),
(12, 'timezone', 'Asia/Kolkata', '2018-10-25 09:05:24', '2018-10-25 09:05:24', NULL),
(13, 'enable_rtl', 'off', '2018-10-25 09:05:24', '2018-10-25 09:05:24', NULL),
(14, 'group_event_privacy', 'only_admins', '2018-10-25 09:05:25', '2018-10-25 09:05:25', NULL),
(15, 'footer_languages', 'on', '2018-10-25 09:05:25', '2018-10-25 09:05:25', NULL),
(16, 'linkedin_link', 'http://linkedin.com/', '2018-10-25 09:05:25', '2018-10-25 09:05:25', NULL),
(17, 'instagram_link', 'http://instagram.com/', '2018-10-25 09:05:25', '2018-10-25 09:05:25', NULL),
(18, 'dribbble_link', 'http://dribbble.com/', '2018-10-25 09:05:25', '2018-10-25 09:05:25', NULL),
(19, 'comment_privacy', 'everyone', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(20, 'confirm_follow', 'no', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(21, 'follow_privacy', 'everyone', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(22, 'user_timeline_post_privacy', 'everyone', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(23, 'post_privacy', 'everyone', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(24, 'page_message_privacy', 'everyone', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(25, 'page_timeline_post_privacy', 'everyone', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(26, 'page_member_privacy', 'only_admins', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(27, 'member_privacy', 'only_admins', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(28, 'group_timeline_post_privacy', 'members', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(29, 'group_member_privacy', 'only_admins', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(30, 'site_name', 'Socialite', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(31, 'site_title', 'Socialite', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(32, 'site_url', 'socialite.dev', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(33, 'twitter_link', 'http://twitter.com/', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(34, 'facebook_link', 'http://facebook.com/', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(35, 'youtube_link', 'http://youtube.com/', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(36, 'support_email', 'admin@socialite.com', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(37, 'mail_verification', 'off', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(38, 'captcha', 'off', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(39, 'censored_words', '', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(40, 'birthday', 'off', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(41, 'city', 'off', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(42, 'about', 'Socialite is the FIRST Social networking script developed on Laravel with all enhanced features, Pixel perfect design and extremely user friendly. User interface and user experience are extra added features to Socialite. Months of research, passion and hard work had made the Socialite more flexible, feature-available and very user friendly!', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(43, 'contact_text', 'Contact page description can be here', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(44, 'address_on_mail', 'Socialite,<br> Socialite street,<br> India', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(45, 'items_page', '10', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(46, 'min_items_page', '5', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(47, 'user_message_privacy', 'everyone', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(48, 'home_welcome_message', 'Welcome To Socialite Laravel Application', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(49, 'home_widget_one', 'Developed on Twitter Bootstrap which makes the application fully responsive on Desktop, Tablet and Mobile', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(50, 'home_widget_two', 'Powerful Admin panel to manage entire application and all kinds of timelines', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(51, 'home_widget_three', 'Emoticons, hashtags, music, youtube video, photos, hangouts and many others can be posted', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(52, 'home_list_heading', 'Enhancing Features of Socialite', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(53, 'home_feature_one_icon', 'users', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(54, 'home_feature_one', 'Find and connect with real people living through out the world', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(55, 'home_feature_two_icon', 'share-alt', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(56, 'home_feature_two', 'Share your posts in other social networks', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(57, 'home_feature_three_icon', 'link', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(58, 'home_feature_three', 'Add links in your posts with new innovative look', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(59, 'home_feature_four_icon', 'bullhorn', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(60, 'home_feature_four', 'Place your google Adsense through out the application', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(61, 'home_feature_five_icon', 'connectdevelop', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(62, 'home_feature_five', 'Connect to Socialite through Facebook, Twitter, Google Plus and Instagram', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(63, 'home_feature_six_icon', 'save', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(64, 'home_feature_six', 'Now you can save your favourite posts, pages, groups and events', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(65, 'home_feature_seven_icon', 'file-photo-o', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(66, 'home_feature_seven', 'Create your albums and upload the pictures right now', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(67, 'home_feature_eight_icon', 'flag-o', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(68, 'home_feature_eight', 'Any page or a post or a group or an event can be reported', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(69, 'home_feature_nine_icon', 'language', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(70, 'home_feature_nine', 'Socialite is multi-lingual and available in 16 languages', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(71, 'home_feature_ten_icon', 'user-plus', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(72, 'home_feature_ten', 'Affiliate System adds an extra flavour to Socialite', '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `static_pages`
--

CREATE TABLE `static_pages` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `slug` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `description` text COLLATE utf8_unicode_ci NOT NULL,
  `active` tinyint(1) NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `static_pages`
--

INSERT INTO `static_pages` (`id`, `title`, `slug`, `description`, `active`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'about', 'about', 'Veritatis et repudiandae enim deserunt. Consequatur iure rerum totam impedit. Quo eos est est sed et. Aliquam aliquid accusantium ut libero eos non. Maiores sed voluptas qui quos consectetur iure.', 1, '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(2, 'privacy', 'privacy', 'Officia harum ipsum rerum. Distinctio laborum voluptatem quia exercitationem sunt ullam modi. Nobis repellat mollitia optio omnis rem quos.', 1, '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(3, 'disclaimer', 'disclaimer', 'Ipsum voluptas nostrum blanditiis iure quam porro id. Soluta fugiat optio est nulla ut vel sit qui.', 1, '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(4, 'terms', 'terms', 'In modi saepe illo modi. Quidem et sed quia voluptas nam. Illum est illum placeat ut dolorem minus. Quo perferendis earum nulla vero itaque laudantium suscipit.', 1, '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `threads`
--

CREATE TABLE `threads` (
  `id` int(10) UNSIGNED NOT NULL,
  `subject` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `timelines`
--

CREATE TABLE `timelines` (
  `id` int(10) UNSIGNED NOT NULL,
  `username` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `name` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `about` text COLLATE utf8_unicode_ci NOT NULL,
  `avatar_id` int(10) UNSIGNED DEFAULT NULL,
  `cover_id` int(10) UNSIGNED DEFAULT NULL,
  `cover_position` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `type` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `hide_cover` int(11) NOT NULL DEFAULT '0',
  `background_id` int(10) UNSIGNED DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `timelines`
--

INSERT INTO `timelines` (`id`, `username`, `name`, `about`, `avatar_id`, `cover_id`, `cover_position`, `type`, `hide_cover`, `background_id`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 'bootstrapguru', 'Admin', 'Some text about me', NULL, NULL, NULL, 'user', 0, NULL, '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(2, 'Gaya3vk', 'gayathri', 'write something about yourself', NULL, NULL, NULL, 'user', 0, NULL, '2018-10-25 10:09:27', '2018-10-25 10:09:27', NULL),
(3, 'Ganga', 'Ganga', 'write something about yourself', NULL, NULL, NULL, 'user', 0, NULL, '2018-10-26 17:05:21', '2018-10-26 17:05:21', NULL),
(4, 'Ramya', 'Ramya', 'write something about yourself', NULL, NULL, NULL, 'user', 0, NULL, '2018-10-26 17:05:50', '2018-10-26 17:05:50', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `timeline_reports`
--

CREATE TABLE `timeline_reports` (
  `id` int(10) UNSIGNED NOT NULL,
  `timeline_id` int(10) UNSIGNED NOT NULL,
  `reporter_id` int(10) UNSIGNED NOT NULL,
  `status` varchar(200) COLLATE utf8_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(10) UNSIGNED NOT NULL,
  `timeline_id` int(10) UNSIGNED NOT NULL,
  `email` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `verification_code` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `verified` tinyint(1) NOT NULL DEFAULT '0',
  `email_verified` tinyint(1) DEFAULT NULL,
  `remember_token` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `password` varchar(250) COLLATE utf8_unicode_ci NOT NULL,
  `balance` double(8,2) NOT NULL DEFAULT '0.00',
  `birthday` date NOT NULL DEFAULT '1970-01-01',
  `city` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `country` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `designation` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `hobbies` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `interests` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `custom_option1` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `custom_option2` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `custom_option3` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `custom_option4` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `gender` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `active` tinyint(1) NOT NULL DEFAULT '1',
  `last_logged` timestamp NULL DEFAULT NULL,
  `timezone` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `affiliate_id` int(10) UNSIGNED DEFAULT NULL,
  `language` varchar(15) COLLATE utf8_unicode_ci DEFAULT NULL,
  `facebook_link` varchar(250) COLLATE utf8_unicode_ci DEFAULT NULL,
  `twitter_link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `dribbble_link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `instagram_link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `youtube_link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `linkedin_link` varchar(255) COLLATE utf8_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `deleted_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `timeline_id`, `email`, `verification_code`, `verified`, `email_verified`, `remember_token`, `password`, `balance`, `birthday`, `city`, `country`, `designation`, `hobbies`, `interests`, `custom_option1`, `custom_option2`, `custom_option3`, `custom_option4`, `gender`, `active`, `last_logged`, `timezone`, `affiliate_id`, `language`, `facebook_link`, `twitter_link`, `dribbble_link`, `instagram_link`, `youtube_link`, `linkedin_link`, `created_at`, `updated_at`, `deleted_at`) VALUES
(1, 1, 'admin@socialite.com', 'D6s7Y1Wtjur384UQxw', 0, 1, 'uw8U6uVWPfNFDN0tPno9Eb9dlPOucUfYZS8FfsMtUCnxIrTTA2jmzipJRmpT', '$2y$10$4GctOd.0TE1fLB8hSQh9buyAPfdjQ7RGJsWK45uoj7wR6DdXfmNQ.', 0.00, '1970-01-01', 'Hyderabad', 'India', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'male', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-10-25 09:05:38', '2018-10-25 09:05:38', NULL),
(2, 2, 'gaya3ravi96@gmail.com', 'v2y0gbCyPM0a3RFJLhs9Eg9J4NXABs', 0, 1, '4EhoSgx9E4869hFRnknBLrVNMoIZycrMNZRT0dOVYa5iM3ry5asStz9b6hRc', '$2y$10$UxEuzeimG7wC.feVm2kji.5PADw1bVcDwL1vjFEJnN0KkyVyIn1QW', 0.00, '1970-01-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'female', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-10-25 10:09:27', '2018-10-25 10:09:27', NULL),
(3, 3, 'ganga@gmail.com', 'YCqngVaG74OJrbpmGDNMLwy0ctw4Xe', 0, 1, 'iWNNEZv7cFPMS2RSRhX1OAEE3IGlyNZ74wuTiCrU6Is7XoItYxAjZ4DmGt2g', '$2y$10$5cP97xQgwG4porzmn4foOevYnfFVfSYimxocRUcZ.JSsTpDx3cKi6', 0.00, '1970-01-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'female', 1, NULL, NULL, NULL, 'en', NULL, NULL, NULL, NULL, NULL, NULL, '2018-10-26 17:05:21', '2018-10-26 19:06:43', NULL),
(4, 4, 'ramya@gmail.com', 'FVG24FtSsBEwLiJdDm4myraw62Vv3q', 0, 1, 'pstnendPSe', '$2y$10$rezbUfiKHhTVvBhWzcc4GO4hxFMO06kvBFwahP8XRbwvm0iIzUXGy', 0.00, '1970-01-01', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'female', 1, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2018-10-26 17:05:50', '2018-10-26 17:05:50', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `user_settings`
--

CREATE TABLE `user_settings` (
  `id` int(10) UNSIGNED NOT NULL,
  `user_id` int(10) UNSIGNED NOT NULL,
  `comment_privacy` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `follow_privacy` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `post_privacy` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `confirm_follow` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `timeline_post_privacy` varchar(15) COLLATE utf8_unicode_ci NOT NULL,
  `message_privacy` varchar(255) COLLATE utf8_unicode_ci NOT NULL DEFAULT '0',
  `email_follow` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'no',
  `email_like_post` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'no',
  `email_post_share` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'no',
  `email_comment_post` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'no',
  `email_like_comment` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'no',
  `email_reply_comment` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'no',
  `email_join_group` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'no',
  `email_like_page` varchar(15) COLLATE utf8_unicode_ci NOT NULL DEFAULT 'no'
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Dumping data for table `user_settings`
--

INSERT INTO `user_settings` (`id`, `user_id`, `comment_privacy`, `follow_privacy`, `post_privacy`, `confirm_follow`, `timeline_post_privacy`, `message_privacy`, `email_follow`, `email_like_post`, `email_post_share`, `email_comment_post`, `email_like_comment`, `email_reply_comment`, `email_join_group`, `email_like_page`) VALUES
(1, 1, 'everyone', 'everyone', 'everyone', 'no', 'everyone', 'everyone', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(2, 2, 'everyone', 'everyone', 'everyone', 'no', 'everyone', 'everyone', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(3, 3, 'everyone', 'everyone', 'everyone', 'yes', 'everyone', 'everyone', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no'),
(4, 4, 'everyone', 'everyone', 'everyone', 'no', 'everyone', 'everyone', 'no', 'no', 'no', 'no', 'no', 'no', 'no', 'no');

-- --------------------------------------------------------

--
-- Table structure for table `wallpapers`
--

CREATE TABLE `wallpapers` (
  `id` int(10) UNSIGNED NOT NULL,
  `title` varchar(255) COLLATE utf8_unicode_ci NOT NULL,
  `media_id` int(10) UNSIGNED NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `albums`
--
ALTER TABLE `albums`
  ADD PRIMARY KEY (`id`),
  ADD KEY `albums_timeline_id_foreign` (`timeline_id`),
  ADD KEY `albums_preview_id_foreign` (`preview_id`);

--
-- Indexes for table `album_media`
--
ALTER TABLE `album_media`
  ADD PRIMARY KEY (`id`),
  ADD KEY `album_media_album_id_foreign` (`album_id`),
  ADD KEY `album_media_media_id_foreign` (`media_id`);

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `announcement_user`
--
ALTER TABLE `announcement_user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `announcement_user_announcement_id_foreign` (`announcement_id`),
  ADD KEY `announcement_user_user_id_foreign` (`user_id`);

--
-- Indexes for table `categories`
--
ALTER TABLE `categories`
  ADD PRIMARY KEY (`id`),
  ADD KEY `categories_parent_id_foreign` (`parent_id`);

--
-- Indexes for table `comments`
--
ALTER TABLE `comments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comments_post_id_foreign` (`post_id`),
  ADD KEY `comments_user_id_foreign` (`user_id`),
  ADD KEY `comments_parent_id_foreign` (`parent_id`),
  ADD KEY `comments_media_id_foreign` (`media_id`);

--
-- Indexes for table `comment_likes`
--
ALTER TABLE `comment_likes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `comment_likes_user_id_foreign` (`user_id`),
  ADD KEY `comment_likes_comment_id_foreign` (`comment_id`);

--
-- Indexes for table `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `events_timeline_id_foreign` (`timeline_id`),
  ADD KEY `events_user_id_foreign` (`user_id`),
  ADD KEY `events_group_id_foreign` (`group_id`);

--
-- Indexes for table `event_user`
--
ALTER TABLE `event_user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_user_event_id_foreign` (`event_id`),
  ADD KEY `event_user_user_id_foreign` (`user_id`);

--
-- Indexes for table `followers`
--
ALTER TABLE `followers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `followers_follower_id_foreign` (`follower_id`),
  ADD KEY `followers_leader_id_foreign` (`leader_id`);

--
-- Indexes for table `groups`
--
ALTER TABLE `groups`
  ADD PRIMARY KEY (`id`),
  ADD KEY `groups_timeline_id_foreign` (`timeline_id`);

--
-- Indexes for table `group_user`
--
ALTER TABLE `group_user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `group_user_group_id_foreign` (`group_id`),
  ADD KEY `group_user_user_id_foreign` (`user_id`),
  ADD KEY `group_user_role_id_foreign` (`role_id`);

--
-- Indexes for table `hashtags`
--
ALTER TABLE `hashtags`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `languages`
--
ALTER TABLE `languages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `media`
--
ALTER TABLE `media`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `notifications_post_id_foreign` (`post_id`),
  ADD KEY `notifications_timeline_id_foreign` (`timeline_id`),
  ADD KEY `notifications_user_id_foreign` (`user_id`),
  ADD KEY `notifications_notified_by_foreign` (`notified_by`);

--
-- Indexes for table `pages`
--
ALTER TABLE `pages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `pages_timeline_id_foreign` (`timeline_id`),
  ADD KEY `pages_category_id_foreign` (`category_id`);

--
-- Indexes for table `page_likes`
--
ALTER TABLE `page_likes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `page_likes_page_id_foreign` (`page_id`),
  ADD KEY `page_likes_user_id_foreign` (`user_id`);

--
-- Indexes for table `page_user`
--
ALTER TABLE `page_user`
  ADD PRIMARY KEY (`id`),
  ADD KEY `page_user_page_id_foreign` (`page_id`),
  ADD KEY `page_user_user_id_foreign` (`user_id`),
  ADD KEY `page_user_role_id_foreign` (`role_id`);

--
-- Indexes for table `participants`
--
ALTER TABLE `participants`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `password_resets`
--
ALTER TABLE `password_resets`
  ADD KEY `password_resets_email_index` (`email`),
  ADD KEY `password_resets_token_index` (`token`);

--
-- Indexes for table `permissions`
--
ALTER TABLE `permissions`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `permissions_name_unique` (`name`);

--
-- Indexes for table `permission_role`
--
ALTER TABLE `permission_role`
  ADD PRIMARY KEY (`permission_id`,`role_id`),
  ADD KEY `permission_role_role_id_foreign` (`role_id`);

--
-- Indexes for table `posts`
--
ALTER TABLE `posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `posts_timeline_id_foreign` (`timeline_id`),
  ADD KEY `posts_user_id_foreign` (`user_id`),
  ADD KEY `posts_shared_post_id_foreign` (`shared_post_id`);

--
-- Indexes for table `post_follows`
--
ALTER TABLE `post_follows`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_follows_post_id_foreign` (`post_id`),
  ADD KEY `post_follows_user_id_foreign` (`user_id`);

--
-- Indexes for table `post_likes`
--
ALTER TABLE `post_likes`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_likes_post_id_foreign` (`post_id`),
  ADD KEY `post_likes_user_id_foreign` (`user_id`);

--
-- Indexes for table `post_media`
--
ALTER TABLE `post_media`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_media_post_id_foreign` (`post_id`),
  ADD KEY `post_media_media_id_foreign` (`media_id`);

--
-- Indexes for table `post_reports`
--
ALTER TABLE `post_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_reports_post_id_foreign` (`post_id`),
  ADD KEY `post_reports_reporter_id_foreign` (`reporter_id`);

--
-- Indexes for table `post_shares`
--
ALTER TABLE `post_shares`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_shares_post_id_foreign` (`post_id`),
  ADD KEY `post_shares_user_id_foreign` (`user_id`);

--
-- Indexes for table `post_tags`
--
ALTER TABLE `post_tags`
  ADD PRIMARY KEY (`id`),
  ADD KEY `post_tags_post_id_foreign` (`post_id`),
  ADD KEY `post_tags_user_id_foreign` (`user_id`);

--
-- Indexes for table `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `role_user`
--
ALTER TABLE `role_user`
  ADD PRIMARY KEY (`user_id`,`role_id`),
  ADD KEY `role_user_role_id_foreign` (`role_id`);

--
-- Indexes for table `saved_posts`
--
ALTER TABLE `saved_posts`
  ADD PRIMARY KEY (`id`),
  ADD KEY `saved_posts_post_id_foreign` (`post_id`),
  ADD KEY `saved_posts_user_id_foreign` (`user_id`);

--
-- Indexes for table `saved_timelines`
--
ALTER TABLE `saved_timelines`
  ADD PRIMARY KEY (`id`),
  ADD KEY `saved_timelines_timeline_id_foreign` (`timeline_id`),
  ADD KEY `saved_timelines_user_id_foreign` (`user_id`);

--
-- Indexes for table `sessions`
--
ALTER TABLE `sessions`
  ADD UNIQUE KEY `sessions_id_unique` (`id`);

--
-- Indexes for table `settings`
--
ALTER TABLE `settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `settings_key_index` (`key`);

--
-- Indexes for table `static_pages`
--
ALTER TABLE `static_pages`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `threads`
--
ALTER TABLE `threads`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `timelines`
--
ALTER TABLE `timelines`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `timelines_username_unique` (`username`),
  ADD KEY `timelines_avatar_id_foreign` (`avatar_id`),
  ADD KEY `timelines_cover_id_foreign` (`cover_id`),
  ADD KEY `timelines_background_id_foreign` (`background_id`);

--
-- Indexes for table `timeline_reports`
--
ALTER TABLE `timeline_reports`
  ADD PRIMARY KEY (`id`),
  ADD KEY `timeline_reports_timeline_id_foreign` (`timeline_id`),
  ADD KEY `timeline_reports_reporter_id_foreign` (`reporter_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD KEY `users_timeline_id_foreign` (`timeline_id`),
  ADD KEY `users_affiliate_id_foreign` (`affiliate_id`);

--
-- Indexes for table `user_settings`
--
ALTER TABLE `user_settings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_settings_user_id_foreign` (`user_id`);

--
-- Indexes for table `wallpapers`
--
ALTER TABLE `wallpapers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `wallpapers_media_id_foreign` (`media_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `albums`
--
ALTER TABLE `albums`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `album_media`
--
ALTER TABLE `album_media`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `announcement_user`
--
ALTER TABLE `announcement_user`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `categories`
--
ALTER TABLE `categories`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `comments`
--
ALTER TABLE `comments`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=29;

--
-- AUTO_INCREMENT for table `comment_likes`
--
ALTER TABLE `comment_likes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `events`
--
ALTER TABLE `events`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `event_user`
--
ALTER TABLE `event_user`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `followers`
--
ALTER TABLE `followers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `groups`
--
ALTER TABLE `groups`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `group_user`
--
ALTER TABLE `group_user`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `hashtags`
--
ALTER TABLE `hashtags`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `languages`
--
ALTER TABLE `languages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `media`
--
ALTER TABLE `media`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=52;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `pages`
--
ALTER TABLE `pages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `page_likes`
--
ALTER TABLE `page_likes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `page_user`
--
ALTER TABLE `page_user`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `participants`
--
ALTER TABLE `participants`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `permissions`
--
ALTER TABLE `permissions`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `posts`
--
ALTER TABLE `posts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `post_follows`
--
ALTER TABLE `post_follows`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `post_likes`
--
ALTER TABLE `post_likes`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `post_media`
--
ALTER TABLE `post_media`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `post_reports`
--
ALTER TABLE `post_reports`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `post_shares`
--
ALTER TABLE `post_shares`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `post_tags`
--
ALTER TABLE `post_tags`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `roles`
--
ALTER TABLE `roles`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `saved_posts`
--
ALTER TABLE `saved_posts`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `saved_timelines`
--
ALTER TABLE `saved_timelines`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `settings`
--
ALTER TABLE `settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=73;

--
-- AUTO_INCREMENT for table `static_pages`
--
ALTER TABLE `static_pages`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `threads`
--
ALTER TABLE `threads`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `timelines`
--
ALTER TABLE `timelines`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `timeline_reports`
--
ALTER TABLE `timeline_reports`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `user_settings`
--
ALTER TABLE `user_settings`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `wallpapers`
--
ALTER TABLE `wallpapers`
  MODIFY `id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `albums`
--
ALTER TABLE `albums`
  ADD CONSTRAINT `albums_preview_id_foreign` FOREIGN KEY (`preview_id`) REFERENCES `media` (`id`),
  ADD CONSTRAINT `albums_timeline_id_foreign` FOREIGN KEY (`timeline_id`) REFERENCES `timelines` (`id`);

--
-- Constraints for table `album_media`
--
ALTER TABLE `album_media`
  ADD CONSTRAINT `album_media_album_id_foreign` FOREIGN KEY (`album_id`) REFERENCES `albums` (`id`),
  ADD CONSTRAINT `album_media_media_id_foreign` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`);

--
-- Constraints for table `announcement_user`
--
ALTER TABLE `announcement_user`
  ADD CONSTRAINT `announcement_user_announcement_id_foreign` FOREIGN KEY (`announcement_id`) REFERENCES `announcements` (`id`),
  ADD CONSTRAINT `announcement_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `categories`
--
ALTER TABLE `categories`
  ADD CONSTRAINT `categories_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `categories` (`id`);

--
-- Constraints for table `comments`
--
ALTER TABLE `comments`
  ADD CONSTRAINT `comments_media_id_foreign` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`),
  ADD CONSTRAINT `comments_parent_id_foreign` FOREIGN KEY (`parent_id`) REFERENCES `comments` (`id`),
  ADD CONSTRAINT `comments_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `comments_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `comment_likes`
--
ALTER TABLE `comment_likes`
  ADD CONSTRAINT `comment_likes_comment_id_foreign` FOREIGN KEY (`comment_id`) REFERENCES `comments` (`id`),
  ADD CONSTRAINT `comment_likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `events`
--
ALTER TABLE `events`
  ADD CONSTRAINT `events_group_id_foreign` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  ADD CONSTRAINT `events_timeline_id_foreign` FOREIGN KEY (`timeline_id`) REFERENCES `timelines` (`id`),
  ADD CONSTRAINT `events_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `event_user`
--
ALTER TABLE `event_user`
  ADD CONSTRAINT `event_user_event_id_foreign` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`),
  ADD CONSTRAINT `event_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `followers`
--
ALTER TABLE `followers`
  ADD CONSTRAINT `followers_follower_id_foreign` FOREIGN KEY (`follower_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `followers_leader_id_foreign` FOREIGN KEY (`leader_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `groups`
--
ALTER TABLE `groups`
  ADD CONSTRAINT `groups_timeline_id_foreign` FOREIGN KEY (`timeline_id`) REFERENCES `timelines` (`id`);

--
-- Constraints for table `group_user`
--
ALTER TABLE `group_user`
  ADD CONSTRAINT `group_user_group_id_foreign` FOREIGN KEY (`group_id`) REFERENCES `groups` (`id`),
  ADD CONSTRAINT `group_user_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `group_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_notified_by_foreign` FOREIGN KEY (`notified_by`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `notifications_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `notifications_timeline_id_foreign` FOREIGN KEY (`timeline_id`) REFERENCES `timelines` (`id`),
  ADD CONSTRAINT `notifications_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `pages`
--
ALTER TABLE `pages`
  ADD CONSTRAINT `pages_category_id_foreign` FOREIGN KEY (`category_id`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `pages_timeline_id_foreign` FOREIGN KEY (`timeline_id`) REFERENCES `timelines` (`id`);

--
-- Constraints for table `page_likes`
--
ALTER TABLE `page_likes`
  ADD CONSTRAINT `page_likes_page_id_foreign` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`),
  ADD CONSTRAINT `page_likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `page_user`
--
ALTER TABLE `page_user`
  ADD CONSTRAINT `page_user_page_id_foreign` FOREIGN KEY (`page_id`) REFERENCES `pages` (`id`),
  ADD CONSTRAINT `page_user_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`),
  ADD CONSTRAINT `page_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `permission_role`
--
ALTER TABLE `permission_role`
  ADD CONSTRAINT `permission_role_permission_id_foreign` FOREIGN KEY (`permission_id`) REFERENCES `permissions` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `permission_role_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `posts`
--
ALTER TABLE `posts`
  ADD CONSTRAINT `posts_shared_post_id_foreign` FOREIGN KEY (`shared_post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `posts_timeline_id_foreign` FOREIGN KEY (`timeline_id`) REFERENCES `timelines` (`id`),
  ADD CONSTRAINT `posts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `post_follows`
--
ALTER TABLE `post_follows`
  ADD CONSTRAINT `post_follows_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `post_follows_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `post_likes`
--
ALTER TABLE `post_likes`
  ADD CONSTRAINT `post_likes_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `post_likes_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `post_media`
--
ALTER TABLE `post_media`
  ADD CONSTRAINT `post_media_media_id_foreign` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`),
  ADD CONSTRAINT `post_media_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`);

--
-- Constraints for table `post_reports`
--
ALTER TABLE `post_reports`
  ADD CONSTRAINT `post_reports_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `post_reports_reporter_id_foreign` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `post_shares`
--
ALTER TABLE `post_shares`
  ADD CONSTRAINT `post_shares_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `post_shares_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `post_tags`
--
ALTER TABLE `post_tags`
  ADD CONSTRAINT `post_tags_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `post_tags_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `role_user`
--
ALTER TABLE `role_user`
  ADD CONSTRAINT `role_user_role_id_foreign` FOREIGN KEY (`role_id`) REFERENCES `roles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE,
  ADD CONSTRAINT `role_user_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Constraints for table `saved_posts`
--
ALTER TABLE `saved_posts`
  ADD CONSTRAINT `saved_posts_post_id_foreign` FOREIGN KEY (`post_id`) REFERENCES `posts` (`id`),
  ADD CONSTRAINT `saved_posts_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `saved_timelines`
--
ALTER TABLE `saved_timelines`
  ADD CONSTRAINT `saved_timelines_timeline_id_foreign` FOREIGN KEY (`timeline_id`) REFERENCES `timelines` (`id`),
  ADD CONSTRAINT `saved_timelines_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `timelines`
--
ALTER TABLE `timelines`
  ADD CONSTRAINT `timelines_avatar_id_foreign` FOREIGN KEY (`avatar_id`) REFERENCES `media` (`id`),
  ADD CONSTRAINT `timelines_background_id_foreign` FOREIGN KEY (`background_id`) REFERENCES `media` (`id`),
  ADD CONSTRAINT `timelines_cover_id_foreign` FOREIGN KEY (`cover_id`) REFERENCES `media` (`id`);

--
-- Constraints for table `timeline_reports`
--
ALTER TABLE `timeline_reports`
  ADD CONSTRAINT `timeline_reports_reporter_id_foreign` FOREIGN KEY (`reporter_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `timeline_reports_timeline_id_foreign` FOREIGN KEY (`timeline_id`) REFERENCES `timelines` (`id`);

--
-- Constraints for table `users`
--
ALTER TABLE `users`
  ADD CONSTRAINT `users_affiliate_id_foreign` FOREIGN KEY (`affiliate_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `users_timeline_id_foreign` FOREIGN KEY (`timeline_id`) REFERENCES `timelines` (`id`);

--
-- Constraints for table `user_settings`
--
ALTER TABLE `user_settings`
  ADD CONSTRAINT `user_settings_user_id_foreign` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `wallpapers`
--
ALTER TABLE `wallpapers`
  ADD CONSTRAINT `wallpapers_media_id_foreign` FOREIGN KEY (`media_id`) REFERENCES `media` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
