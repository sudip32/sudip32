var $$FSR = {
  'enabled': true,
  'frames': false,
  'sessionreplay': true,
  'auto': true,
  'encode': true,
  'version': '18.1.0',
  'files': '/foresee/',
  // The 'swf_files' attribute needs to be set when foresee_transport.swf is not located at 'files'
  //'swf_files': '/some/other/location/'
  'id': 'tBo4kkEFtcBIYIp5BhoUgA4C',
  'definition': 'foresee_surveydef.js',
  'swf': {
    'fileName': 'foresee_transport.swf',
    'scriptAccess': 'always'
  },
  'worker': 'foresee_worker.js',
  'embedded': false,
  'replay_id': 'answers.com',
  'site_id': 'answers.com',
  'attach': false,
  'renderer': 'W3C',
  // or "ASRECORDED"
  'layout': 'CENTERFIXED',
  // or "LEFTFIXED" or "LEFTSTRETCH" or "CENTERSTRETCH"
  'triggerDelay': 0,
  'heartbeat': true,
  'enableAMD': false,
  'pools': [{
    'path': '.',
    'sp': 15 // CHANGE ONLY WHEN INCLUDING SESSION REPLAY
  }],
  'sites': [{
    'path': /\w+-?\w+\.(com|org|edu|gov|net|co\.uk)/
  },
  {
    'path': '.',
    'domain': 'default'
  }],
  'storageOption': 'cookie',
  'nameBackup': window.name,
  'iframeHrefs': ["frameWorker.html"],
  'acceptableorigins': []
};

$$FSR.FSRCONFIG = {};

(function (config) {

  var FSR, supports_amd = !! config.enableAMD && typeof(_4c.global["define"]) === 'function' && !! _4c.global["define"]["amd"];

  if (!supports_amd) FSR = window.FSR;
  else FSR = {};
/*
* ForeSee Survey Def(s)
*/
  FSR.surveydefs = [{
    name: 'FB_auth_UB',
    invite: {
      when: 'onentry'
    },
    pop: {
      when: 'later'
    },
    pin: 1,
    criteria: {
      sp: 100,
      lf: 1
    },
    include: {
      variables: [{
        name: 'foresee_custom_vars.lmi',
        value: '1212'
      }]
    }
  },
  {
    name: 'browse_UB',
    section: 'temp-Foresee',
    brand: 'Foresee',
    invite: {
      when: 'onentry',
      //corpLogo: 'fsrlogo.gif',
      corpLogo: 'Foresee.gif',
      corpAltText: 'Foresee'
    },
    pop: {
      when: 'later'
    },
    criteria: {
      sp: 7.5,
      lf: 1
    },
    include: {
      urls: ['.']
    }
  },
  {
    name: 'browse_UB',
    section: 'temp-Answers',
    brand: 'Answers',
    invite: {
      when: 'onentry',
      //corpLogo: 'fsrlogo.gif',
      corpLogo: 'Answers.gif',
      corpAltText: 'Answers'
    },
    pop: {
      when: 'later'
    },
    criteria: {
      sp: 7.5,
      lf: 1
    },
    include: {
      urls: ['.']
    }
  },
  {
    name: 'browse_UB',
    section: 'temp-ForeseeByAnswers',
    brand: 'ForeseeByAnswers',
    invite: {
      when: 'onentry',
      //corpLogo: 'fsrlogo.gif',
      corpLogo: 'fsrlogo.png',
      corpAltText: 'Foresee By Answers'
    },
    pop: {
      when: 'later'
    },
    criteria: {
      sp: 7.5,
      lf: 1
    },
    include: {
      urls: ['.']
    }
  }];


/*
* ForeSee Properties
*/
  FSR.properties = {
    repeatdays: 90,

    repeatoverride: false,

    altcookie: {},

    brands: [{
      "c": "Foresee",
      "p": 33
    },
    {
      "c": "Answers",
      "p": 33
    },
    {
      "c": "ForeseeByAnswers",
      "p": 34
    }],

    language: {
      locale: 'en'
    },

    exclude: {},

    zIndexPopup: 10000,

    ignoreWindowTopCheck: false,

    ipexclude: 'fsr$ip',

    mobileHeartbeat: {
      delay: 60,
      /*mobile on exit heartbeat delay seconds*/
      max: 3600 /*mobile on exit heartbeat max run time seconds*/
    },

    invite: {

      // For no site logo, comment this line:
      siteLogo: "sitelogo.gif",

      //alt text fore site logo img
      siteLogoAlt: "",

      /* Desktop */
      dialogs: [
        [{
          reverseButtons: false,
          headline: "We'd welcome your feedback!",
          blurb: "Thank you for visiting our website. You have been selected to participate in a brief customer satisfaction survey to let us know how we can improve your experience.",
          noticeAboutSurvey: "The survey is designed to measure your entire experience, please look for it at the <u>conclusion</u> of your visit.",
          attribution: "This survey is conducted by an independent company ForeSee, on behalf of the site you are visiting.",
          closeInviteButtonText: "Click to close.",
          declineButton: "No, thanks",
          acceptButton: "Yes, I'll give feedback",
          error: "Error",
          warnLaunch: "this will launch a new window"
        }]
      ],

      exclude: {
        urls: [],
        referrers: [],
        userAgents: [],
        browsers: [],
        cookies: [],
        variables: []
      },
      include: {
        local: ['.']
      },

      delay: 0,
      timeout: 0,

      hideOnClick: false,

      hideCloseButton: false,

      css: 'foresee_dhtml.css',

      hide: [],

      hideFlash: false,

      type: 'dhtml',
      /* desktop */
      // url: 'invite.html'
      /* mobile */
      url: 'invite-mobile.html',
      back: 'url'

      //SurveyMutex: 'SurveyMutex'
    },

    tracker: {
      width: '690',
      height: '415',
      timeout: 15,
      fasttimeout: 4,
      adjust: true,
      alert: {
        enabled: true,
        message: 'The survey is now available.'
      },
      url: 'tracker.html'
    },

    survey: {
      width: 690,
      height: 600
    },

    qualifier: {
      footer: '<div id=\"fsrcontainer\"><div style=\"float:left;width:80%;font-size:8pt;text-align:left;line-height:12px;\">This survey is conducted by an independent company ForeSee,<br>on behalf of the site you are visiting.</div><div style=\"float:right;font-size:8pt;\"><a target="_blank" title="Validate TRUSTe privacy certification" href="//privacy-policy.truste.com/click-with-confidence/ctv/en/www.foreseeresults.com/seal_m"><img border=\"0\" src=\"{%baseHref%}truste.png\" alt=\"Validate TRUSTe Privacy Certification\"></a></div></div>',
      width: '690',
      height: '500',
      bgcolor: '#333',
      opacity: 0.7,
      x: 'center',
      y: 'center',
      delay: 0,
      buttons: {
        accept: 'Continue'
      },
      hideOnClick: false,
      css: 'foresee_dhtml.css',
      url: 'qualifying.html'
    },

    cancel: {
      url: 'cancel.html',
      width: '690',
      height: '400'
    },

    pop: {
      what: 'survey',
      after: 'leaving-site',
      pu: false,
      tracker: true
    },

    meta: {
      referrer: true,
      terms: true,
      ref_url: true,
      url: true,
      url_params: false,
      user_agent: false,
      entry: false,
      entry_params: false,
      viewport_size: false,
      document_size: false,
      scroll_from_top: false
    },

    events: {
      enabled: true,
      id: true,
      codes: {
        purchase: 800,
        items: 801,
        dollars: 802,
        followup: 803,
        information: 804,
        content: 805
      },
      pd: 7,
      custom: {}
    },

    previous: false,

    analytics: {
      google_local: false,
      google_remote: false
    },

    cpps: {
      LMI: {
        source: 'variable',
        name: 'foresee_custom_vars.lmi'
      },
      GUID: {
        source: 'variable',
        name: 'foresee_custom_vars.guid'
      },
      age: {
        source: 'variable',
        name: 'foresee_custom_vars.age'
      },
      categories: {
        source: 'variable',
        name: 'foresee_custom_vars.categories'
      },
      cur_id: {
        source: 'variable',
        name: 'foresee_custom_vars.cur_id'
      },
      gender: {
        source: 'variable',
        name: 'foresee_custom_vars.gender'
      },
      y_rate: {
        source: 'variable',
        name: 'foresee_custom_vars.y_rate'
      },
      is_logged_in: {
        source: 'variable',
        name: 'foresee_custom_vars.is_logged_in'
      },
      profile_type: {
        source: 'variable',
        name: 'foresee_custom_vars.profile_type'
      },
      page: {
        source: 'variable',
        name: 'foresee_custom_vars.page'
      }
    },

    mode: 'first-party',

    pattern: 'page'
  };
  if (supports_amd) {
    define(function () {
      return FSR
    });
  }

})($$FSR);