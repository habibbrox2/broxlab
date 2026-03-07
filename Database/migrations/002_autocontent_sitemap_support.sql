-- AutoContent Sitemap Support Migration
-- This script adds XML Sitemap support and related columns to the AutoContent system

-- ============================================================================
-- STEP 1: Update autocontent_sources type ENUM to include 'xml'
-- ============================================================================

ALTER TABLE autocontent_sources 
MODIFY COLUMN type ENUM
('rss', 'html', 'api', 'scrape', 'xml') DEFAULT 'rss';

-- ============================================================================
-- STEP 2: Add new columns for sitemap and content type support
-- ============================================================================

-- Add content_type column (articles, pages, mobiles, or services)
ALTER TABLE autocontent_sources 
ADD COLUMN
IF NOT EXISTS content_type ENUM
('articles', 'pages', 'mobiles', 'services') DEFAULT 'articles' AFTER type;

-- Add max_pages for sitemap crawling
ALTER TABLE autocontent_sources 
ADD COLUMN
IF NOT EXISTS max_pages INT DEFAULT 50 AFTER fetch_interval;

-- Add delay between requests (in seconds)
ALTER TABLE autocontent_sources 
ADD COLUMN
IF NOT EXISTS delay INT DEFAULT 2 AFTER max_pages;

-- Add scrape_depth column for multi-layer crawling
ALTER TABLE autocontent_sources 
ADD COLUMN
IF NOT EXISTS scrape_depth INT DEFAULT 1 AFTER content_type;

-- Add use_browser column for browser rotation
ALTER TABLE autocontent_sources 
ADD COLUMN
IF NOT EXISTS use_browser TINYINT
(1) DEFAULT 0 AFTER scrape_depth;

-- ============================================================================
-- STEP 3: Create autocontent_crawl_queue table for sitemap crawling
-- ============================================================================

CREATE TABLE
IF NOT EXISTS autocontent_crawl_queue
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    source_id INT NOT NULL,
    url VARCHAR
(2048) NOT NULL,
    url_hash VARCHAR
(64) DEFAULT '',
    status ENUM
('pending', 'processing', 'completed', 'failed') DEFAULT 'pending',
    depth INT DEFAULT 0,
    retry_count INT DEFAULT 0,
    error_message TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL ON
UPDATE CURRENT_TIMESTAMP,
    INDEX idx_source_id (source_id),
    INDEX idx_status (status),
    INDEX idx_url_hash (url_hash),
    INDEX idx_created_at (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- STEP 4: Create autocontent_mobiles table for mobile phone data
-- ============================================================================

CREATE TABLE
IF NOT EXISTS autocontent_mobiles
(
    id INT AUTO_INCREMENT PRIMARY KEY,
    source_id INT DEFAULT NULL,
    source_url VARCHAR
(2048) NOT NULL,
    title VARCHAR
(500) DEFAULT '',
    price VARCHAR
(255) DEFAULT '',
    brand VARCHAR
(100) DEFAULT '',
    model VARCHAR
(255) DEFAULT '',
    image_url VARCHAR
(2048) DEFAULT '',
    specifications JSON,
    release_date VARCHAR
(100) DEFAULT '',
    status ENUM
('collected', 'processing', 'processed', 'published', 'failed') DEFAULT 'collected',
    scraped_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT NULL ON
UPDATE CURRENT_TIMESTAMP,
    UNIQUE KEY unique_source_url (source_url(500)),
    INDEX idx_source_id
(source_id),
    INDEX idx_brand
(brand),
    INDEX idx_status
(status),
    INDEX idx_scraped_at
(scraped_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================================
-- MIGRATION COMPLETE!
-- ============================================================================
-- The AutoContent system now supports:
-- - XML Sitemap crawling
-- - Content type selection (articles/mobiles)
-- - Crawl queue management
-- - Mobile phone data storage
