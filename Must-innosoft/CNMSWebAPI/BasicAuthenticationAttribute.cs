using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Http.Controllers;
using System.Web.Http.Filters;
using System.Net.Http;
using System.Net;
using System.Text;
using System.Threading;
using System.Security.Principal;

namespace CNMSWebAPI
{
    public class BasicAuthenticationAttribute :AuthorizationFilterAttribute
    {
        public override void OnAuthorization(HttpActionContext actionContext)
        {
            if (actionContext.Request.Headers.Authorization.Parameter == "null")
            {
                actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
            }
            else
            {
                string authenticationTokan = actionContext.Request.Headers.Authorization.Parameter;
                string decodeauthenticationTokan= Encoding.UTF8.GetString(Convert.FromBase64String(authenticationTokan));
                string[] usernamepassword = decodeauthenticationTokan.Split(':');
                string code = usernamepassword[0];
                string username = usernamepassword[1];
                string password = usernamepassword[2];
                
                if (UserSecurity.Login(code, username, password))
                {
                    Thread.CurrentPrincipal = new GenericPrincipal(new GenericIdentity(code), null);
                }
                else
                {
                    actionContext.Response = actionContext.Request.CreateResponse(HttpStatusCode.Unauthorized);
                }
            }
        }
    }
}