import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:recruiter_app/core/constants.dart';
import 'package:recruiter_app/widgets/common_appbar_widget.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  late AnimationController _controller;
  late Animation<Offset> _appbarAnimation;
  late Animation<Offset> _listAnimation;
  late Animation<double> _expandAnimation;

  // List of FAQ items with questions and answers
  final List<Map<String, dynamic>> faqItems = [
    {
      'question': 'How do I showcase my achievement after I get certified?',
      'answer':
          'You may share the link on professional and social networking platforms.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is a verifiable certificate?',
      'answer':
          'Each certificate will carry a unique web link which will help in the validation.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'How do I get recertified after expiry of the certification validity?',
      'answer': 'Register, take the test and get certified again.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is the validity of the certification?',
      'answer': '2 years from the date of certification.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How much does the Naukrigulf certification cost?',
      'answer':
          'Introductory period offer: Certification and test are FREE of cost.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is the test format for Certification?',
      'answer': 'Online Proctored MCQ based test',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Where and when can I take the Naukrigulf certification exam?',
      'answer':
          'Register here. We will give you a call and fix a suitable time for taking the test at your convenience on a desktop/laptop.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'When I click on Login button, it says "Login already in use", what should I do?',
      'answer':
          'This message appears when you have not logged out from the account properly clicking on logout button. The session automatically expires after half an hour, so wait till the defined time. Alternately, please get in touch with us at bugs@naukrigulf.com',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Whom should I contact if I face any problems while using my account?',
      'answer':
          'You can use either of our support options: \nReport the problem directly to cs@naukrigulf.com\nContact your respective Sales Account Manager or the Client Servicing Manager of your account',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'Why do I keep getting logged out of my account?',
      'answer':
          'If you have been logged out of your Naukrigulf account, it is probably because your login session has expired. This means that you have not used the application for 30 minutes after you logged in It is always recommended click on the "Logout" link at the top after you finish using Naukrigulf.com account. This is to avoid any timeouts and prevent unsaved changes from being lost.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'Can I buy more logins for Resdex?',
      'answer':
          'Yes, for this please contact your respective Sales Account Manager',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How many sub-users can I create?',
      'answer':
          'By default, you can create 9 sub users by clicking on "Add User" button. However, you can grant Resdex access rights only to one sub user. So, 2 people can simultaneously access Resdex - 1 Super User and 1 Sub User. In case you wish to revoke Resdex access rights from the Super User and grant to 2 sub users instead, you may do so. Further, if you want to add more than 9 sub-users, please contact your respective Sales Account Manager.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Can I assign Resdex access to sub users added in my account?',
      'answer':
          '''Yes, you can grant product usage permissions to specific users in case you' re logged in as a super- user. For this,
"Login to Naukrigulf.com account as a super-user "Go to "Manage Accounts" section and click on "Manage Users" in the drop-down " Go to the sub-user to whom you wish to assign Resdex permissions and click on edit icon, make the required changes and click "Submit changes".''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is the difference between a super-user and a sub-user?',
      'answer':
          'A super-user has the admin rights on the entire account created for a company. A Super User can create/delete / manage sub-users. It can also monitor account usage, assign various permissions to sub-users, subscribe to new services, and renew existing subscriptions. A Super User can also by default access Resdex and Post jobs, manage responses through RM.\nA sub-user can access database, post jobs, manage responses through RM and change his sub- user password.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'How can employers access and activate these features on Naukrigulf to elevate their recruitment efforts?',
      'answer':
          'Employers can easily access and activate Top Employer, Featured Employer, Branded Mailers, and Premium Job Posting features by connecting with sales team allowing them to leverage these tools efficiently for their hiring needs.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'Why should employers use the PCS tool?',
      'answer':
          '1. You can create a roster of potential candidates who show interest in your jobs.\n2. You can customize career section as per your existing site.\n3. It simplifies posting jobs and sorting through applicants.\n4. It functions smoothly on mobile devices and is user-friendly, simplifying the recruitment process.\n5. It offers various options for sharing on social media, extending your visibility.\n6. It resolves any technical or hosting issues you may have.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Can I customize the appearance and branding of my career site using PCS?',
      'answer':
          'Absolutely! PCS allows full customization of your career site. Employers can personalize their career pages by adding company logos, language preference (English and Arabic versions available), branding elements, custom domain names, and content to align with their brand identity.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is the PCS tool by Naukrigulf?',
      'answer':
          '''The PCS tool helps you convert your website visitors into job applicants. Here's what it does:
1. You receive an affordable cloud-based hiring solution that leverages your website's visitors.
2. It gives you a personalized job site that matches your brand.
3. It provides a one-stop platform for you to see who's applied.
4. You can pick the best candidates with Al-Powered smart filters.
5. It offers you an Arabic careers site to tap into local talent.
''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Is the salary information based on entry-level, mid-level, or senior-level positions?',
      'answer':
          'Naukrigulf Salary Tool aims to provide a range that covers different experience levels for a particular job position, including entry-level, mid-level, and senior-level roles.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'How do you ensure data security and gain user trust? Is it possible to verify ownership of Λ the website and thus prevent attackers from creating a fake version of the site?',
      'answer':
          '''An SSL certificate is provided with PCS tools. This prevents security errors and allows to verify site ownership.
An SSL certificate works by using encryption algorithms to scramble data in transit which prevents hackers from reading it.
This includes encryption protocols, secure servers, access controls, and compliance with industry standards for data protection.
Moreover, Google Search recognizes sites with SSL certificates installed and rewards them with higher search results ranking than sites that don't have an SSL certificate.''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Can I compare salaries between different industries using this tool?',
      'answer':
          'Yes, our Salary Tool allows users to compare salaries across different industries to gain insights into how compensation varies across various sectors.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          '''Does Naukrigulf's Salary Tool consider variations in salaries for various GCC countries?''',
      'answer':
          'Yes, Salary Tool allows to select countries in GCC to provide users with more localized and relevant salary estimates based on location-specific data.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          '''How accurate are the salary estimates provided by Naukrigulf's Salary Tool? Is the data reliable?''',
      'answer':
          '''The Salary Tool utilizes a localized approach with a large dataset, validated from over 2 million job seekers in Gulf countries. The salary estimates provided by Naukrigulf's Salary Tool are based on a combination of user-submitted data, industry research, and algorithmic calculations. These figures might however vary based on multiple factors like location, experience, and industry trends. The estimations therefore should be used as a reference point rather than definitive figures, as actual salaries may vary based on varied circumstances.''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How frequently is the data updated in the Salary Tool?',
      'answer':
          'We update our salary data daily to reflect changes in the job market.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'What factors influence the salary ranges displayed for a job position?',
      'answer':
          'The salary ranges are influenced by various factors such as job title, gender, nationality, industry, functional area, geographic location, years of experience and key skills.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Is the Salary Tool user-friendly? How easy is it to navigate and utilize the data?',
      'answer':
          'The interface is designed to be user-friendly, allowing easy navigation and access to detailed salary information. The data is presented in a structured format, allowing straightforward interpretation and usage. This ensures the latest and most comprehensive salary data available, downloadable in PDF and Excel formats.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'In what ways does the tool provide sophisticated perspectives on salary information, particularly regarding industry-specific breakdowns and demographic differentiations?',
      'answer':
          'Naukrigulf Salary tool goes beyond basic analysis, offering sophisticated perspectives on salary data. It provides specialized insights such as industry-specific salary breakdowns and detailed demographic differentiations based on factors like nationality, gender, and more. This data aims to enable the user with a comprehensive and detailed examination of compensation patterns.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How many number of designations I can select?',
      'answer':
          'The tool allows users to select up to three designations from a dropdown list. This feature ensures that your search results encompass similar roles, accommodating variations in job titles while providing relevant salary information.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Is it possible to view salary information in local GCC currencies?',
      'answer':
          'Absolutely, our tool supports viewing salaries in all distinct GCC currencies, providing localized insights for users in the region.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'How does the tool present salary information, and what distinct metrics does it offer, like Λ salary average, median, and percentile?',
      'answer':
          'Our tool provides an array of insightful salary metrics to enrich your understanding. These three metrics collectively provide diverse insights into salary ranges, catering to varied analytical needs. \n• Average Salary: Reflects the typical earnings calculated by summing all salaries and dividing by the total number of data points.\n• Median Salary: Represents the middle point of a dataset, offering a balanced view of earnings unaffected by extreme values.\n• Percentile: Illustrates the salary point below which Minimum, 25 percentile, 50 percentile, 75 percentile, 90 percentile and Maximum of salaries fall, indicating the upper-tier earnings for a specific role or industry.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How can employers use this data to their advantage?',
      'answer':
          'Employers can advertise jobs with competitive pay scales based on the insights provided by the tool, attracting the right talent for their vacancies. They can also benchmark salaries to ensure alignment with industry standards and effectively manage internal salary-related issues.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How can the Salary Tool benefit employers or recruiters?',
      'answer':
          'The tool assists in formulating competitive bids for manpower supply by providing accurate salary data across different job profiles. This data helps in building realistic cost estimates and enables better decision-making during bidding processes.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is the Naukrigulf Salary Tool?',
      'answer':
          'The Naukrigulf Salary Tool is a comprehensive resource that offers detailed salary analysis and insights for various job profiles across different industries in the Gulf countries. ',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'What is the difference between CV Folder and My Folder in Naukrigulf?',
      'answer':
          'CV Folder contains CV that you manually shortlist from Resdex search.\nMy Folder contains CV that you manually shortlist from applications received for job Posting done.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'What is the word limit for entering keywords in Keyword / Boolean Search in Naukrigulf?',
      'answer': 'No Limit',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is Resume Freshness?',
      'answer':
          'Resume Freshness indicates when a candidate was last active on the site. You can search the resumes in Resdex based on Last Active Date of the candidate.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'If I add a comment on a CV, can I see it throughout my subscription duration?',
      'answer': 'Yes',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Is there a limit on number of CV Folders / Search Agents / Mail templates/My Folder that I can create?',
      'answer': 'Yes, Max 50',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How can I print a resume?',
      'answer':
          '''To print a resume, click on Print button on resume preview page. This will show the resume preview in detail. Click on the 'Print' to print the resume.''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'What are LEGENDS that are seen at the bottom of search results page?',
      'answer':
          'Legends are icons that appear alongside the brief preview of candidate CV on SRP page. They indicate the activity done on each candidate for a quick understanding.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Can I add notes to the resumes for additional information or future reference?',
      'answer':
          'Yes, you can add additional notes to a resume by using the "Add comments" option available at the top-right on the resume preview page. Click on that button and enter the desired comments. You can add upto 10 comments for a CV.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Is it possible to download the resumes that I like or wish to refer later on?',
      'answer':
          '''To download the resume that you' re currently viewing, simply click on the "Download" option available at the top of the resume detail page.''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Can I create templates for the emails I wish to send to candidates rather than creating a new email message every time?',
      'answer':
          '''Yes, for this you need to create Email templates using these steps: \n•Click on the tab 'Email Templates'. Click the button 'Create New Template'\n• This will open up a dialog box. Specify the Template name, Subject, From and Compile the email message and click on 'Submit'. \nThis template will be listed in the Email Template section for you to use it when required.''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What are Saved Searches and Alerts?',
      'answer':
          '''Saved searches are search criteria that are saved for you to run the search at any point of time without having to fill up the Search Form.\nAlerts are the mails that you receive whenever any new resume matching your saved search criteria enters the resume database. Set Alerts by following process-\n• Go to the section 'Saved Searches and Alerts' for any previously saved search. You can set the alert frequency by clicking on the Email Alerts Status dropdown. An alert can be set to daily/weekly / monthly occurrence.\n• Alternately, you can also set an alert while saving your search from the SRP page.\n• Click on 'Save this search' and name the search and set a frequency for alerts in the subsequent dialog box. Here you may also add/select an email ID where you wish to receive the resume alerts. Click Save.

''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How can I save resumes that I like during my search?',
      'answer':
          'To save the desired resumes from the SRP page\n• Go to the SRP page, check the box against the resume(s) you wish to save/move into a folder.\n• Click on the "Save to Folder" button at the top. You may select an existing Folder to save or Create a new Folder.\nTo save resumes from the resume details page',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How can I view details of a resume?',
      'answer':
          'To view a resume:\n• Conduct a search by entering the required parameters in the Search Form and click on Search Button.\n• On SRP page, click on the resume heading of the candidate. This will open the resume preview with its details',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How can I contact candidates from Resdex?',
      'answer':
          '''You can contact candidates in two ways: call on the given number OR send mail to the respective email ID.\n• Send out emails from your Resdex account to the candidates by selecting the desired resume(s) in SRP page.\n• Click 'Email' button displayed on top. It will display a dialog box with a drop-down of an existing email template. You can also compose a new email by filling in the details and click on' Send Email' button''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': '''What is 'Refine your search result' ?''',
      'answer':
          '''Refine your search results further segregates the total CVs found into certain pre-defined categories. For example, after you've performed a search and wish to see the number of resumes against each 'Nationality' in that search, you can refer the Nationality cluster. Furthermore, you can even click on the desired 'Nationality' to refer to your target set.''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': '''What are 'Keywords' in the Resdex Search Form?''',
      'answer':
          '''The Keyword field in the RESDEX search form refers to word(s) to be searched within the candidate's CV.\nFor more specific search, you can use the Designation search''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': '''What are 'Keywords' in the Resdex Search Form?''',
      'answer':
          '''The Keyword field in the RESDEX search form refers to word(s) to be searched within the candidate's CV.\nFor more specific search, you can use the Designation search.
''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How can I search with my Resdex subscription?',
      'answer':
          'You can search for candidates in our resume database by clicking on "Search CVs". It will display a Search Form containing 27 different search parameters. You can fill in the desired details and click on the Search Button.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How do I benefit from Resdex?',
      'answer':
          'Resdex is an extensive database of job-seeker profiles. It gives an easy access to 10 million plus strong database of candidates in the gulf region. It helps you filter from 27 different criteria. You can save the desired CV in folders and easily access them whenever required.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How can I search within results?',
      'answer':
          '''Once you click on the Search button, it takes you to the SRP page where a brief preview of CVs gets displayed. Here you can further refine your search results by going to the tab 'Search within results'\nYou can input the criteria in the 'search within results' text box and click 'Search'.
.''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is Response Manager?',
      'answer':
          'Response Manager is the central repository of applications received for all jobs posted. You can search on specific parameters like Keywords / Experience/Country/ Nationality / Custom Questions etc. for desired applications on any specific job. You can also download applications in Excel format and Word Format',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'Can I share a posted job within my network?',
      'answer':
          'Yes, once posted, a recruiter can share the jobs on following networking sites- Facebook, Twitter & Linkedin.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What Is Auto Fill and Auto Save?',
      'answer':
          'Auto-Fill: Save your efforts by reusing the job information already filled up.\nAuto-Save: As you fill in the job details the job posting from is saved automatically after every few minutes to ensure that data is not lost during loss in network connections or in case of session time-out.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is Xpress JD Builder?',
      'answer':
          'Xpress JD Builder guides the recruiter to give a structure to the Job Description on few pre-defined criteria. It helps you to create a better JD template.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What are Custom Questions?',
      'answer':
          'Custom Questions help you to add job-specific questions further filtering best matched responses from job advertisements. Candidates will be prompted to answer these questions when they apply for job.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How can I filter out irrelevant applications?',
      'answer':
          'You can set Filet on Gender, Nationality and Custom Questions to define your preferred criteria Additionally, you search and refine through various tools provided in the RM section',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          '''How do I modify a job vacancy that I've already posted on the site?''',
      'answer':
          'To modify a posted job, you need to follow these steps:\nLogin to your account and click on "Job Postings". Go to "Manage Jobs".\nClick "Edit" icon shown against the job you wish to edit. This will take you to the pre-filled job posting form for that job. Make the desired changes there and finally post the job.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          '''How do I view the applications/responses received for the job that I've posted?''',
      'answer':
          '''For the job that you've posted on Naukrigulf, applications will by default be collected in Response management & collection software called Response Manager. Additionally you can also add upto 9 email IDs to collect responses for posted job''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How do I delete a live job if the position is closed?',
      'answer':
          '''If you wish to remove a live job from the site:\nGo to the manage jobs section\nClick on the 'Delete' icon against the job which you want to remove''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          '''What happens to my job after 60 days? What are 'Expired Jobs' ?''',
      'answer':
          '''The jobs that have completed 60 days are marked as 'Expired Jobs' in Response Manager. The applications received for these jobs are still available to you for a period of 8 months from the date of posting, after which they are permanently deleted from our database.''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': '''What is meant by 'Refresh' a job?''',
      'answer':
          'Refreshing your job advertisement means extending its duration on the site. Each refresh consumes a job from your subscription. This implies that if you have subscribed to a pack of 5 jobs, you can either post 5 jobs or post one job and refresh it 4 times.\nIn case, you have purchased a single job posting, you will not be able to refresh it.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'How do I add additional email ids to receive applications? Is there any limit on the number of email ids allowed?',
      'answer':
          'You can add upto 9 email IDs to receive applications from a job posting in the job posting form.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'How long will it take for my job to get reflected on Naukrigulf.com site?',
      'answer':
          'It takes 30 minutes maximum for a job posted to be visible on the site once you click on submit button.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How can I post a job on Naukrigulf.com?',
      'answer':
          'Follow these steps to post a job-\n• Login to your account with the username and password and Go to "Job Posting" » Post a Job • Fill the Job Posting form, preview and post it.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'How do I know the number of job postings left in my subscription?',
      'answer':
          '''You can view this information within your account in 'Job Posting Credit Meter'.''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'What are the different variants of Job Posting subscription?',
      'answer':
          'Our Job Posting solution has 2 variants: Post a Job and Post a Premium Job. You may choose a subscription pack as per your need.\nPost a Premium Job\nThis is our premium job posting services that includes company branding (displaying logo and template with your jobs)\nPost a Job\nThis is our basic job posting service that includes basic job details without branding.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'What are Job Postings? What all can I do with your Job Postings solution?',
      'answer':
          'Job Posting is a customized solution for recruiters and employers filling open positions by inviting applications from interested candidates.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'Can I buy more logins for Resdex?',
      'answer':
          'Yes, for this please contact your respective Sales Account Manager',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Is it possible to download the resumes that I like or wish to refer later on?',
      'answer':
          '''To download the resume that you' re currently viewing, simply click on the "Download" option available at the top of the resume detail page.
''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'What is the difference between CV Folder and My Folder in Naukrigulf? ',
      'answer':
          'CV Folder contains CV that you manually shortlist from Resdex search.\nMy Folder contains CV that you manually shortlist from applications received for job Posting done.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is Resume Freshness?',
      'answer':
          'Resume Freshness indicates when a candidate was last active on the site. You can search the resumes in Resdex based on Last Active Date of the candidate.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'How long will it take for my job to get reflected on Naukrigulf.com site?',
      'answer':
          'It takes 30 minutes maximum for a job posted to be visible on the site once you click on submit button.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How can I save resumes that I like during my search?',
      'answer':
          '''To save the desired resumes from the SRP page\n• Go to the SRP page, check the box against the resume (s) you wish to save/move into a folder.\n• Click on the "Save to Folder" button at the top. You may select an existing Folder to save or Create a new Folder.\nTo save resumes from the resume details page\n• Click on the "Save to Folder" button and save in a previously existing folder or you may create a new folder.\nOnce you've saved/moved the desired CV(s) to the folder, you can view them by going to the CV folder section.''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'Why do I keep getting logged out of my account?',
      'answer':
          'If you have been logged out of your Naukrigulf account, it is probably because your login session has expired. This means that you have not used the application for 30 minutes after you logged in It is always recommended click on the "Logout" link at the top after you finish using Naukrigulf.com account. This is to avoid any timeouts and prevent unsaved changes from being lost.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Apart from increased visibility, what are the primary benefits of Branding on Naukrigulf?',
      'answer':
          '''Branding solution on Naukrigulf offers several advantages:\n• Enhanced Credibility: The placement of Branded Logos and Banners signifies commitment to excellence in workplace practices, elevating an employer's credibility among job seekers.\n• Attracting Top Talent: It helps in attracting top-tier candidates seeking opportunities with reputable organizations. It allows increased exposure through strategic positioning, distinct company logo, and heightened visibility.\n• Customized Templates: Branded Mailers enable employers to send personalized and branded emails directly to a targeted set of potential candidates, fostering direct engagement and reinforcing brand awareness. Branded Mailers are highly customizable and allow employers to personalize content while targeting specific candidate segments based on various criteria such as skills, location, and experience.\n• Highlight company logo and banner in each job: Premium Job Posting ensures standing out from other jobs and receive maximum exposure to reach a wider audience of qualified candidates.''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'For how long will my posted jobs remain advertised in the site?',
      'answer':
          'All jobs remain live on the site for 60 days from the date of posting.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is the test format for Certification?',
      'answer': 'Online Proctored MCQ based test',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is the validity of the certification?',
      'answer': '2 years from the date of certification',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': '''What are 'Keywords' in the Resdex Search Form?''',
      'answer':
          '''The Keyword field in the RESDEX search form refers to word(s) to be searched within the candidate's CV.\nFor more specific search, you can use the Designation search.
''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Can I assign Resdex access to sub users added in my account?',
      'answer':
          '''Yes, you can grant product usage permissions to specific users in case you' re logged in as a super- user. For this,\n"Login to Naukrigulf.com account as a super-user" Go to "Manage Accounts" section and click on "Manage Users" in the drop-down " Go to the sub-user to whom you wish to assign Resdex permissions and click on edit icon, make the required changes and click "Submit changes".
''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How much does the Naukrigulf certification cost?',
      'answer':
          'Introductory period offer: Certification and test are FREE of cost',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How many sub-users can I create?',
      'answer':
          'By default, you can create 9 sub users by clicking on "Add User" button. However, you can grant Resdex access rights only to one sub user. So, 2 people can simultaneously access Resdex - 1 Super User and 1 Sub User. In case you wish to revoke Resdex access rights from the Super User and grant to 2 sub users instead, you may do so. Further, if you want to add more than 9 sub-users, please contact your respective Sales Account Manager.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'What are Job Postings? What all can I do with your Job Postings solution?',
      'answer':
          'Job Posting is a customized solution for recruiters and employers filling open positions by inviting applications from interested candidates.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Whom should I contact if I face any problems while using my account?',
      'answer':
          'You can use either of our support options:\nReport the problem directly to cs@naukrigulf.com\nContact your respective Sales Account Manager or the Client Servicing Manager of your account.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is the PCS tool by Naukrigulf?',
      'answer':
          '''The PCS tool helps you convert your website visitors into job applicants. Here's what it does:\n1. You receive an affordable cloud-based hiring solution that leverages your website's visitors.\n 2. It gives you a personalized job site that matches your brand.\n3. It provides a one-stop platform for you to see who's applied.\n4. You can pick the best candidates with Al-Powered smart filters.\n5. It offers you an Arabic careers site to tap into local talent.
''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Is there a limit on number of CV Folders / Search Agents / Mail templates/My Folder that I Λ can create?',
      'answer': 'Yes, Max 50',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'How do I know the number of job postings left in my subscription?',
      'answer':
          '''You can view this information within your account in 'Job Posting Credit Meter'.
''',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'What are the different variants of Job Posting subscription?',
      'answer':
          'Our Job Posting solution has 2 variants: Post a Job and Post a Premium Job. You may choose a subscription pack as per your need.\nPost a Premium Job\nThis is our premium job posting services that includes company branding (displaying logo and template with your jobs)\nPost a Job\nThis is our basic job posting service that includes basic job details without branding.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'What is the difference between a super-user and a sub-user?',
      'answer':
          'A super-user has the admin rights on the entire account created for a company. A Super User can create/delete / manage sub-users. It can also monitor account usage, assign various permissions to sub-users, subscribe to new services, and renew existing subscriptions. A Super User can also by default access Resdex and Post jobs, manage responses through RM.\nA sub-user can access database, post jobs, manage responses through RM and change his sub- user password.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How do I benefit from Resdex?',
      'answer':
          'Resdex is an extensive database of job-seeker profiles. It gives an easy access to 10 million plus strong database of candidates in the gulf region. It helps you filter from 27 different criteria. You can save the desired CV in folders and easily access them whenever required.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Can employers track the performance and engagement metrics of their Branding inventory on Naukrigulf?',
      'answer':
          'Yes, Naukrigulf provides detailed analytics and reports, offering insights into open rates, click- through rates and candidate interactions.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'How can I get started with PCS for my company?',
      'answer':
          'Getting started with PCS is simple!\nYou can reach out to our sales or customer service team (cs.naukrigulf@naukrigulf.com) through our website to discuss your requirements, schedule a demo, and begin the process of setting up your customized career site.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question': 'Can I post job openings from my PCS directly to Naukrigulf?',
      'answer':
          'Yes, PCS allows seamless integration with Naukrigulf, enabling employers to post job openings simultaneously for maximum visibility.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          '''Is there a technical support available for setting up and managing PCS on my company's A website?''',
      'answer':
          'Yes, Naukrigulf offers technical support and assistance throughout the setup and management of PCS.Our dedicated support team ensures a smooth onboarding process and ongoing assistance as needed.',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'What is the prerequisite for attempting Advanced Recruiter Certification?',
      'answer':
          'We strongly recommend to complete Basic Recruiter Certification before applying for Advanced Recruiter Certification',
      'isExpanded': false,
      'isHelpful': null,
    },
    {
      'question':
          'Apart from increased visibility, what are the primary benefits of Branding on Naukrigulf? ',
      'answer':
          '''Branding solution on Naukrigulf offers several advantages:\n• Enhanced Credibility: The placement of Branded Logos and Banners signifies commitment to excellence in workplace practices, elevating an employer's credibility among job seekers.\n• Attracting Top Talent: It helps in attracting top-tier candidates seeking opportunities with reputable organizations. It allows increased exposure through strategic positioning, distinct company logo, and heightened visibility.\n• Customized Templates: Branded Mailers enable employers to send personalized and branded emails directly to a targeted set of potential candidates, fostering direct engagement and reinforcing brand awareness. Branded Mailers are highly customizable and allow employers to personalize content while targeting specific candidate segments based on various criteria such as skills, location, and experience.\n• Highlight company logo and banner in each job: Premium Job Posting ensures standing out from other jobs and receive maximum exposure to reach a wider audience of qualified candidates.
''',
      'isExpanded': false,
      'isHelpful': null,
    },
  ];

  // Filter FAQ items based on search query
  List<Map<String, dynamic>> get filteredFaqItems {
    if (_searchQuery.isEmpty) {
      return faqItems;
    }
    return faqItems.where((item) {
      final question = item['question'].toString().toLowerCase();
      final answer = item['answer'].toString().toLowerCase();
      final searchLower = _searchQuery.toLowerCase();
      return question.contains(searchLower) || answer.contains(searchLower);
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    _controller.forward();

    _appbarAnimation = Tween<Offset>(
            begin: const Offset(-0.6, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _listAnimation = Tween<Offset>(
            begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _expandAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height.h;
    final theme = Theme.of(context);
    return Material(
      child: Scaffold(
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: screenHeight * 0.45,
              child: SvgPicture.asset(
                "assets/svgs/onboard_1.svg",
                fit: BoxFit.cover,
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  SlideTransition(
                      position: _appbarAnimation,
                      child: const CommonAppbarWidget(
                        title: "FAQs",
                        isBackArrow: true,
                      )),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        prefixIcon:
                            const Icon(Icons.search, color: greyTextColor),
                        suffixIcon: _searchQuery.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear,
                                    color: greyTextColor),
                                onPressed: () {
                                  setState(() {
                                    _searchController.clear();
                                    _searchQuery = '';
                                  });
                                },
                              )
                            : null,
                        filled: true,
                        fillColor: Colors.grey[100],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 16),
                      ),
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                    ),
                  ),
                  Expanded(
                      child: filteredFaqItems.isEmpty
                          ? const Center(
                              child: Text(
                                'No matching FAQs found',
                                style: TextStyle(color: greyTextColor),
                              ),
                            )
                          : SlideTransition(
                              position: _listAnimation,
                              child: ListView.builder(
                                padding: const EdgeInsets.all(16.0),
                                itemCount: filteredFaqItems.length,
                                itemBuilder: (context, index) {
                                  final item = filteredFaqItems[index];
                                  return AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    margin: const EdgeInsets.only(bottom: 16.0),
                                    child: Card(
                                      color: item['isExpanded'] == true
                                          ? secondaryColor
                                          : Colors.white,
                                      elevation: 2,
                                      child: Theme(
                                        data: Theme.of(context).copyWith(
                                          dividerColor: Colors.transparent,
                                          splashFactory: NoSplash.splashFactory,
                                      splashColor: Colors.transparent,
                                      highlightColor: Colors.transparent
                                        ),
                                        child: ExpansionTile(
                                          key: Key(index
                                              .toString()), // Add key for unique identification
                                          title: Text(
                                            item['question'],
                                            style: theme.textTheme.titleLarge!
                                                .copyWith(
                                              fontSize: 14.sp,
                                              color: item['isExpanded'] == true
                                                  ? Colors.white
                                                  : Colors.black,
                                            ),
                                          ),
                                          onExpansionChanged: (expanded) {
                                            setState(() {
                                              item['isExpanded'] = expanded;
                                            });
                                            print(item['isExpanded']);
                                          },
                                          trailing: RotationTransition(
                                            turns: Tween(begin: 0.0, end: 0.25)
                                                .animate(_expandAnimation),
                                            child:  Icon(
                                              item['isExpanded'] == true
                                              ? Icons.keyboard_arrow_right
                                    
                                               : Icons.keyboard_arrow_up,
                                               color: item['isExpanded'] == true
                                              ? Colors.white
                                              : Colors.black,
                                               ),
                                          ),
                                          children: [
                                            AnimatedSize(
                                              duration: const Duration(
                                                  milliseconds: 300),
                                              curve: Curves.easeInOut,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      item['answer'],
                                                      style: theme
                                                          .textTheme.bodyMedium!
                                                          .copyWith(
                                                        color:
                                                            item['isExpanded'] ==
                                                                    true
                                                                ? Colors.white
                                                                : Colors.black,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                        height: 16.0),
                                                    Row(
                                                      children: [
                                                        // ... rest of your existing row content ...
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )

                      // SlideTransition(
                      //   position: _listAnimation,
                      //   child: ListView.builder(
                      //       padding: const EdgeInsets.all(16.0),
                      //       itemCount: filteredFaqItems.length,
                      //       itemBuilder: (context, index) {
                      //         final item = filteredFaqItems[index];
                      //         return Card(
                      //           color: const Color.fromARGB(255, 236, 234, 234),
                      //           elevation: 2,
                      //           margin: const EdgeInsets.only(bottom: 16.0),
                      //           child: ExpansionTile(
                      //             title: Text(
                      //               item['question'],
                      //               style: const TextStyle(
                      //                 fontWeight: FontWeight.bold,
                      //                 color: Colors.black,
                      //               ),
                      //             ),
                      //             onExpansionChanged: (expanded) {
                      //               setState(() {
                      //                 item['isExpanded'] = expanded;
                      //               });
                      //             },
                      //             children: [
                      //               Padding(
                      //                 padding: const EdgeInsets.all(16.0),
                      //                 child: Column(
                      //                   crossAxisAlignment:
                      //                       CrossAxisAlignment.start,
                      //                   children: [
                      //                     Text(
                      //                       item['answer'],
                      //                       style: const TextStyle(
                      //                         color: Colors.black,
                      //                       ),
                      //                     ),
                      //                     const SizedBox(height: 16.0),
                      //                     Row(
                      //                       children: [
                      //                         const Text(
                      //                           'Was this answer helpful?',
                      //                           style: TextStyle(
                      //                             color: Colors.black,
                      //                             fontSize: 14.0,
                      //                           ),
                      //                         ),
                      //                         const SizedBox(width: 16.0),
                      //                         IconButton(
                      //                           icon: Icon(
                      //                             Icons.thumb_up,
                      //                             size: 18,
                      //                             color:
                      //                                 item['isHelpful'] == true
                      //                                     ? buttonColor
                      //                                     : greyTextColor,
                      //                           ),
                      //                           onPressed: () {
                      //                             setState(() {
                      //                               if (item['isHelpful'] ==
                      //                                   true) {
                      //                                 item['isHelpful'] = null;
                      //                               } else {
                      //                                 item['isHelpful'] = true;
                      //                               }
                      //                             });
                      //                           },
                      //                         ),
                      //                         IconButton(
                      //                           icon: Icon(
                      //                             Icons.thumb_down,
                      //                             size: 18,
                      //                             color:
                      //                                 item['isHelpful'] == false
                      //                                     ? buttonColor
                      //                                     : greyTextColor,
                      //                           ),
                      //                           onPressed: () {
                      //                             setState(() {
                      //                               if (item['isHelpful'] ==
                      //                                   false) {
                      //                                 item['isHelpful'] = null;
                      //                               } else {
                      //                                 item['isHelpful'] = false;
                      //                               }
                      //                             });
                      //                           },
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   ],
                      //                 ),
                      //               ),
                      //             ],
                      //           ),
                      //         );
                      //       },
                      //     ),
                      // ),

                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
