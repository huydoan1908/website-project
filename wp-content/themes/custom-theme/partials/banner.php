<?php
$banner_image = get_field('banner_image');
$banner_content = get_field('banner_content');
?>
<section class="hero-section">
    <picture class="hero-background">
        <source srcset="<?php echo $banner_image['desktop']; ?>" media="(min-width: 768px)">
        <img src="<?php echo $banner_image['mobile']; ?>" alt="Hero Background">
    </picture>
    
    <div class="hero-content">
        <p class="hero-tagline"><?= $banner_content["subtitle"]; ?></p>
        <h1 class="hero-title"><?= $banner_content["title"]; ?></h1>
    </div>
</section>