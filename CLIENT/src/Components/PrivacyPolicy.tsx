import React from 'react';
import { LinearGradient } from 'react-text-gradients';

const PrivacyPolicy = () => {
  return (
    <div className="bg-app-bg text-white p-6">
      <h1 className="text-6xl font-bold mb-7 text-center pt-2">
        <LinearGradient gradient={['to left', '#17acff ,#ff68f0']} className="gradient-title">
          Melosynthia AI Privacy Policy
        </LinearGradient>
      </h1>

      <p className="mb-4 text-xl">
        Last Updated: August 11, 2023
      </p>

      <p>
        This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service and tells You about Your privacy rights and how the law protects You. We use Your Personal data to provide and improve the Service. By using the Service, You agree to the collection and use of information in accordance with this Privacy Policy.
      </p>

      <h2 className="text-lg font-semibold mt-4 section-title">Interpretation and Definitions</h2>
      <h3 className="text-md font-semibold mt-2">Interpretation</h3>
      <p>
        The words of which the initial letter is capitalized have meanings defined
        under the following conditions. The following definitions shall have the same
        meaning regardless of whether they appear in singular or in plural.
      </p>

      <h3 className="text-md font-semibold mt-2">Definitions</h3>
      <p>
        For the purposes of this Privacy Policy:
      </p>
      <ul className="list-disc pl-6">
        <li><strong>Account</strong> means a unique account created for You to access our Service or parts of our Service.</li>
        <li><strong>Affiliate</strong> means an entity that controls, is controlled by or is under common control with a party, where "control" means ownership of 50% or more of the shares, equity interest or other securities entitled to vote for election of directors or other managing authority.</li>
        <li><strong>Company</strong> (referred to as either "the Company", "We", "Us" or "Our" in this Agreement) refers to WEB-3 Sailors, India.</li>
        <li>Cookies are small files that are placed on Your computer, mobile device or any other device by a website, containing the details of Your browsing history on that website among its many uses.</li>
        <li>Country refers to: Delhi, India</li>
        <li>Device means any device that can access the Service such as a computer, a cellphone or a digital tablet.</li>
        <li>Personal Data is any information that relates to an identified or identifiable individual. </li>
        <li>Service refers to the Website. </li>
        <li>Service Provider means any natural or legal person who processes the data on behalf of the Company. It refers to third-party companies or individuals employed by the Company to facilitate the Service, to provide the Service on behalf of the Company, to perform services related to the Service or to assist the Company in analyzing how the Service is used </li>
        <li>Third-party Social Media Service refers to any website or any social network website through which a User can log in or create an account to use the Service.</li>
        <li>Usage Data refers to data collected automatically, either generated by the use of the Service or from the Service infrastructure itself (for example,the duration of a page visit). </li>
        <li>Website refers to MeloSynthia AI, accessible from [melosynthiaai.com](melosynthiaai.com)</li>
        <li>You means the individual accessing or using the Service, or the company, or other legal entity on behalf of which such individual is accessing or using the Service, as applicable.</li>
      </ul>

      <h2 className="text-lg font-semibold mt-4 section-title">Collecting and Using Your Personal Data </h2>
      <p>

      </p>

      {/* ... Continue with the rest of the content ... */}
      <h2 className="text-lg font-semibold mt-4 section-title">Changes to this Privacy Policy</h2>
      <p>
       We may update Our Privacy Policy from time to time. We will notify You of any changes by posting the new Privacy Policy on this page. We will let You know via email and/or a prominent notice on Our Service, prior to the change becoming effective and update the "Last updated" date at the top of this Privacy Policy.
      </p>
      <p> 
       You are advised to review this Privacy Policy periodically for any changes. Changes to this Privacy Policy are effective when they are posted on this page.
      </p>
    
      <h2 className="text-2xl font-semibold mt-4 section-title">Contact Us</h2>
      <p>
        If you have any questions about this Privacy Policy, You can contact us:
      </p>
      <ul className="list-disc pl-6 mb-6">
        <li>By email: ayushmanmohanty0503@gmail.com</li>
      </ul>
    </div>
  );
};

export default PrivacyPolicy;
