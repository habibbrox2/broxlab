-- AutoContent Database Migration
-- This script creates new tables for Auto Content system with enhanced selectors
-- Run this SQL to set up the new database structure

-- ============================================================================
-- STEP 1: Drop old AutoBlog tables (backup data first if needed!)
-- ============================================================================

-- Drop old autoblog tables if they exist
DROP TABLE IF EXISTS autoblog_articles;
DROP TABLE IF EXISTS autoblog_sources;
DROP TABLE IF EXISTS autoblog_settings;
DROP TABLE IF EXISTS autoblog_queue;
DROP TABLE IF EXISTS autoblog_scrape_logs;
DROP TABLE IF EXISTS autoblog_scrape_queue;

-- Drop old autocontent tables if they exist (in case of re-run)
DROP TABLE IF EXISTS autocontent_articles;
DROP TABLE IF EXISTS autocontent_sources;
DROP TABLE IF EXISTS autocontent_settings;

-- ============================================================================
-- STEP 2: Create autocontent_sources table
-- ============================================================================
CREATE TABLE
IF NOT EXISTS autocontent_sources
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR
(255) NOT NULL,
    url TEXT NOT NULL,
    type ENUM
('rss', 'html', 'api', 'scrape') DEFAULT 'rss',
    category_id INT DEFAULT NULL,
    selectors TEXT,
    -- List page selectors
    selector_list_container VARCHAR
(500) DEFAULT '',
    selector_list_item VARCHAR
(500) DEFAULT '',
    selector_list_title VARCHAR
(500) DEFAULT '',
    selector_list_link VARCHAR
(500) DEFAULT '',
    selector_list_date VARCHAR
(500) DEFAULT '',
    selector_list_image VARCHAR
(500) DEFAULT '',
    -- Detail page selectors
    selector_title VARCHAR
(500) DEFAULT '',
    selector_content VARCHAR
(500) DEFAULT '',
    selector_image VARCHAR
(500) DEFAULT '',
    selector_excerpt VARCHAR
(500) DEFAULT '',
    selector_date VARCHAR
(500) DEFAULT '',
    selector_author VARCHAR
(500) DEFAULT '',
    -- Additional selectors
    selector_pagination VARCHAR
(500) DEFAULT '',
    selector_read_more VARCHAR
(500) DEFAULT '',
    selector_category VARCHAR
(500) DEFAULT '',
    selector_tags VARCHAR
(500) DEFAULT '',
    selector_video VARCHAR
(500) DEFAULT '',
    selector_audio VARCHAR
(500) DEFAULT '',
    selector_source_url VARCHAR
(500) DEFAULT '',
    fetch_interval INT DEFAULT 3600,
    is_active TINYINT
(1) DEFAULT 1,
    last_fetched_at DATETIME DEFAULT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_is_active
(is_active),
    INDEX idx_last_fetched
(last_fetched_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- STEP 3: Create autocontent_articles table
-- ============================================================================
CREATE TABLE
IF NOT EXISTS autocontent_articles
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    source_id INT NOT NULL,
    url VARCHAR
(2048) NOT NULL,
    title VARCHAR
(500) DEFAULT '',
    content LONGTEXT,
    excerpt TEXT,
    author VARCHAR
(255) DEFAULT '',
    image_url VARCHAR
(2048) DEFAULT '',
    published_at DATETIME DEFAULT NULL,
    status ENUM
('collected', 'processing', 'processed', 'approved', 'published', 'failed') DEFAULT 'collected',
    ai_title VARCHAR
(500) DEFAULT '',
    ai_content LONGTEXT,
    ai_summary TEXT,
    ai_excerpt TEXT,
    seo_score INT DEFAULT 0,
    original_content LONGTEXT,
    content_hash VARCHAR
(64) DEFAULT '',
    simhash VARCHAR
(64) DEFAULT '',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL ON
UPDATE CURRENT_TIMESTAMP,
    INDEX idx_source_id (source_id),
    INDEX idx_status (status),
    INDEX idx_published_at (published_at),
    INDEX idx_created_at (created_at),
    INDEX idx_url (url(500)),
    INDEX idx_content_hash (content_hash)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- STEP 4: Create autocontent_settings table
-- ============================================================================
CREATE TABLE
IF NOT EXISTS autocontent_settings
(
    setting_key VARCHAR
(100) PRIMARY KEY,
    setting_value TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL ON
UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- MIGRATION COMPLETE!
-- ============================================================================
-- The new Auto Content system is now ready to use.
-- All old autoblog_* tables have been dropped.
-- All new autocontent_* tables have been created with enhanced selectors.
