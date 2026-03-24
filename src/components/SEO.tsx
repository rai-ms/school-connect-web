import { Helmet } from 'react-helmet-async';

interface SEOProps {
  title?: string;
  description?: string;
  keywords?: string;
  url?: string;
  image?: string;
}

const defaults = {
  title: 'School Connect – All-in-One School Management System',
  description:
    'Transform your school operations with School Connect. Role-based access, attendance, homework, fees, reports, and more. 7-day free trial available.',
  keywords:
    'school management system, education software, student management, teacher portal, parent communication, attendance tracking, fee management, exam management, school ERP',
  url: 'https://school-connect-web-curm.onrender.com',
  image: 'https://school-connect-web-curm.onrender.com/og-image.jpg',
};

const SEO = ({
  title = defaults.title,
  description = defaults.description,
  keywords = defaults.keywords,
  url = defaults.url,
  image = defaults.image,
}: SEOProps) => (
  <Helmet>
    <title>{title}</title>
    <meta name="description" content={description} />
    <meta name="keywords" content={keywords} />
    <link rel="canonical" href={url} />

    {/* Open Graph */}
    <meta property="og:type" content="website" />
    <meta property="og:url" content={url} />
    <meta property="og:title" content={title} />
    <meta property="og:description" content={description} />
    <meta property="og:image" content={image} />
    <meta property="og:site_name" content="School Connect" />

    {/* Twitter */}
    <meta name="twitter:card" content="summary_large_image" />
    <meta name="twitter:url" content={url} />
    <meta name="twitter:title" content={title} />
    <meta name="twitter:description" content={description} />
    <meta name="twitter:image" content={image} />

    {/* Structured Data - Organization */}
    <script type="application/ld+json">
      {JSON.stringify({
        '@context': 'https://schema.org',
        '@type': 'SoftwareApplication',
        name: 'School Connect',
        applicationCategory: 'EducationalApplication',
        operatingSystem: 'Web, Android, iOS',
        description,
        offers: {
          '@type': 'AggregateOffer',
          priceCurrency: 'INR',
          lowPrice: '0',
          highPrice: '999',
          offerCount: '3',
        },
        aggregateRating: {
          '@type': 'AggregateRating',
          ratingValue: '4.8',
          ratingCount: '500',
        },
      })}
    </script>

    {/* Structured Data - Organization */}
    <script type="application/ld+json">
      {JSON.stringify({
        '@context': 'https://schema.org',
        '@type': 'Organization',
        name: 'School Connect',
        url,
        logo: `${url}/logo.png`,
        contactPoint: {
          '@type': 'ContactPoint',
          email: 'support@schoolconnect.com',
          contactType: 'customer service',
        },
      })}
    </script>
  </Helmet>
);

export default SEO;
