using CNMSDataAccess;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Security.Principal;
using System.Text;
using System.Threading;
using System.Web;
using System.Web.Http;


namespace CNMSWebAPI.Controllers
{

    public class UserLoginController : ApiController
    {
        //int userrole = 0;

        //long clientid = 0;
        //string message = "";
        //Boolean status = true;
        //[AllowAnonymous]
        //[HttpPost]
        //public HttpResponseMessage Authenticate([FromBody] UserDetail login)
        //{
        //    string Username = login.Username;
        //    string Password = login.Password;
        //    string ClientCode = login.ClientCode;
        //    if (CheckUser(Username, Password, ClientCode))
        //    {



        //        var tokenString = JwtAuthentication.GenerateToken(Username, clientid);



        //        return Request.CreateResponse(HttpStatusCode.OK, new { message, status, userrole, tokenString });

        //    }
        //    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
        //    //throw new HttpResponseException(HttpStatusCode.Unauthorized);
        //}

        //private bool CheckUser(string username, string password, string clientCode)
        //{
        //    using (ConstructionDBEntities ent = new ConstructionDBEntities())
        //    {
        //        ent.Configuration.ProxyCreationEnabled = false;
        //        var dat = ent.UserDetails.FirstOrDefault(c => c.ClientCode == clientCode && c.Username == username && c.Password == password);
        //        if (dat != null)
        //        {
        //            if (dat.Status == 1)
        //            {
        //                userrole = dat.User_Role_Id;
        //                clientid = Convert.ToInt64(dat.ClientId);
        //                if (dat.ExprieDate > DateTime.Now)
        //                {
        //                    DateTime today = DateTime.Now;
        //                    TimeSpan difference = Convert.ToDateTime(dat.ExprieDate) - today;

        //                    var days = Math.Round(difference.TotalDays, 0) + 1;
        //                    if (60 >= days)
        //                    {
        //                        message = "Login Successfully, User validity is expire soon! Remaining Days is " + days;
        //                        return true;
        //                    }
        //                    message = "Login Successfully";
        //                    return true;
        //                }
        //                else
        //                {
        //                    DateTime today = DateTime.Now;
        //                    TimeSpan difference = Convert.ToDateTime(dat.ExprieDate) - today;

        //                    var days = Math.Round(difference.TotalDays, 0) + 1;
        //                    if (0 >= days)
        //                    {
        //                        dat.Status = 0;

        //                        ent.SaveChanges();
        //                    }
        //                    message = "User validity is expired, contact Admin";
        //                    status = false;
        //                    return false;
        //                }
        //            }
        //            else
        //            {
        //                message = "User is Blocked Contact Admin";
        //                status = false;
        //                 return false;

        //            }
        //        }
        //        else
        //        {

        //            message = "User details does not exists";
        //            status = false;
        //            return false;
        //        }
        //    }

        //}
        
        private
        const string sec = "401b09eab3c013d4ca54922bb802bec8fd5318192b0a75f201d8b3727429090fb337591abd3e44453b954555b7a0812e1081c39b740293f765eae731f5a65ed1";
        [HttpPost]
        [AllowAnonymous]
        //public HttpResponseMessage Get(string CCode, string Username, string Password)
        public HttpResponseMessage Authenticate([FromBody] UserDetail login)
        {
            string code = Thread.CurrentPrincipal.Identity.Name;

            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                string message = "";
                Boolean status = true;
                ent.Configuration.ProxyCreationEnabled = false;
                var dat = ent.UserDetails.FirstOrDefault(c => c.ClientCode == login.ClientCode && c.Username == login.Username && c.Password == login.Password);
                //var dat = ent.UserDetails.FirstOrDefault(c => c.ClientCode == CCode && c.Username == Username && c.Password == Password);
                if (dat != null)
                {
                    if (dat.Status == 1)
                    {
                        int userrole = dat.User_Role_Id;
                        long clientid = Convert.ToInt64(dat.ClientId);
                        long userId = Convert.ToInt64(dat.UserId);
                        DateTime dnow = DateTime.Now;
                        HttpContext.Current.Session.Add("CNMSuserId", userId);
                        //const string sec = "401b09eab3c013d4ca54922bb802bec8fd5318192b0a75f201d8b3727429090fb337591abd3e44453b954555b7a0812e1081c39b740293f765eae731f5a65ed1";

                        var now = DateTime.UtcNow;
                        var securityKey = new Microsoft.IdentityModel.Tokens.SymmetricSecurityKey(Encoding.Default.GetBytes(sec));
                        var signingCredentials = new Microsoft.IdentityModel.Tokens.SigningCredentials(
                            securityKey,
                            Microsoft.IdentityModel.Tokens.SecurityAlgorithms.HmacSha256);

                        var header = new JwtHeader(signingCredentials);

                        var payload = new JwtPayload
                        {
                               
                                    {"iss", "a5fgde64-e84d-485a-be51-56e293d09a69"},
                                    { "userrole",userrole},
                                    { "clientid",clientid},
                                    { "userId",userId},
                                    { "Sesdatetime",dnow},

                        };

                        var secToken = new JwtSecurityToken(header, payload);

                        var handler = new JwtSecurityTokenHandler();
                        var tokenString = handler.WriteToken(secToken);

                        //var simplePrinciple = Models.JwtAuthentication.GetPrincipal(tokenString);
                        //var identity = simplePrinciple?.Identity as ClaimsIdentity;

                        
                        //var tok = JwtAuthentication.GenerateToken(login.Username, clientid, userrole, 20);


                        var cop = ent.Clients.Where(a => a.ClientId == clientid).Select(a => a.ContactPerson).FirstOrDefault();

                        if (dat.ExprieDate > DateTime.Now)
                        {
                            //if (dat.MaintanceDate > DateTime.Now)
                            //{
                            //    DateTime today1 = DateTime.Now;
                            //    TimeSpan difference1 = Convert.ToDateTime(dat.MaintanceDate) - today1;

                            //    var days1 = Math.Round(difference1.TotalDays, 0) + 1;
                            //    if (60 >= days1)
                            //    {
                            //        message = "Login Successfully, User maintance is expire soon! Remaining Days is " + days1;

                            //        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            //    }




                            //}
                            //else
                            //{
                            //    message = "User maintance is expired, contact Admin";
                            //    status = false;
                            //    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            //}

                            //Set Session
                            string ClientCode = "";

                            var session = HttpContext.Current.Session;
                            if (session != null)
                            {
                                if (session["ClientCode"] == null)
                                    session["ClientCode"] = dat.ClientCode;

                            }
                            //Get Session
                            if (session["ClientCode"] != null)
                                ClientCode = session["ClientCode"].ToString();

                            DateTime today = DateTime.Now;
                            TimeSpan difference = Convert.ToDateTime(dat.ExprieDate) - today;

                            var days = Math.Round(difference.TotalDays, 0) + 1;
                            if (60 >= days)
                            {
                                //if (0 >= days)
                                //{
                                //    dat.Status = 0;
                                //    ent.UserDetails.Add(dat);
                                //    ent.SaveChanges();
                                //}

                                if (clientid != 0)
                                    message = "Hi " + cop + ", Validity is expire soon! Remaining Days is " + days;
                                else
                                    message = "Hi, Admin";

                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status, tokenString });
                            }

                            if (clientid != 0)
                                message = "Hi "+ cop;
                            else
                                message = "Hi, Admin";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status,  tokenString });
                        }
                        else
                        {
                                
                                
                            DateTime today = DateTime.Now;
                            TimeSpan difference = Convert.ToDateTime(dat.ExprieDate) - today;

                            var days = Math.Round(difference.TotalDays, 0) + 1;
                            if (0 >= days)
                            {
                                dat.Status = 0;
                                if (clientid != 0)
                                    ent.SaveChanges();
                            }
                            
                            
                            message = "User validity is expired, contact Admin";
                            status = false;
                            if (clientid != 0)
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            else
                            {
                                message = "Hi, Admin";
                                status = true;
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status, tokenString });
                            }
                        }



                    }
                    else
                    {
                        message = "User is Blocked Contact Admin";
                        status = false;
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    }
                }
                else
                {
                    //return Request.CreateErrorResponse(HttpStatusCode.NotFound, "User details does not exists");
                    message = "User details does not exists";
                    status = false;
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                }
            }
        }
        public HttpResponseMessage Get()
        {
            return Request.CreateResponse(HttpStatusCode.OK);

        }
        private void SetPrincipal(IPrincipal principal)
        {
            Thread.CurrentPrincipal = principal;
            if (HttpContext.Current != null)
            {
                HttpContext.Current.User = principal;
            }
        }
        //    [HttpPost]
        //    public IHttpActionResult Authenticate([FromBody] UserDetail login)
        //    {
        //        string message = "";
        //        Boolean status = true;
        //        var loginResponse = new HttpResponseMessage{ };
        //        UserDetail loginrequest = new UserDetail { };
        //        loginrequest.Username = login.Username.ToLower();
        //        loginrequest.Password = login.Password;
        //        loginrequest.ClientCode = login.ClientCode;

        //        IHttpActionResult response;
        //        HttpResponseMessage responseMsg = new HttpResponseMessage();
        //        bool isUsernamePasswordValid = false;


        //        using (ConstructionDBEntities ent = new ConstructionDBEntities())
        //        {

        //            ent.Configuration.ProxyCreationEnabled = false;
        //            var dat = ent.UserDetails.FirstOrDefault(c => c.ClientCode == loginrequest.ClientCode && c.Username == loginrequest.Username && c.Password == loginrequest.Password);
        //            if (dat != null)
        //            {
        //                if (dat.Status == 1)
        //                {
        //                    int userrole = dat.User_Role_Id;
        //                    if (login != null)
        //                        isUsernamePasswordValid = loginrequest.Password == dat.Password ? true : false;
        //                    // if credentials are valid
        //                    if (isUsernamePasswordValid)
        //                    {
        //                        string tokenString = createToken(loginrequest.Username);
        //                        //return the token
        //                        return Ok<string>(tokenString);
        //                        //message = "Login Successfully";
        //                        //return Request.CreateResponse(HttpStatusCode.OK, new { message, status, userrole, tokenString });
        //                    }
        //                    else
        //                    {
        //                        // if credentials are not valid send unauthorized status code in response
        //                        loginResponse.StatusCode = HttpStatusCode.Unauthorized;
        //                        response = ResponseMessage(loginResponse);
        //                        return response;
        //                    }
        //                }
        //                else
        //                {
        //                    loginResponse.StatusCode = HttpStatusCode.Unauthorized;
        //                    response = ResponseMessage(loginResponse);
        //                    return response;
        //                }

        //            }
        //            else {
        //                loginResponse.StatusCode = HttpStatusCode.Unauthorized;
        //                response = ResponseMessage(loginResponse);
        //                return response;
        //            }
        //        }
        //    }

        //    private string createToken(string username)
        //    {
        //        //Set issued at date
        //        DateTime issuedAt = DateTime.UtcNow;
        //        //set the time when it expires
        //        DateTime expires = DateTime.UtcNow.AddDays(7);

        //        //http://stackoverflow.com/questions/18223868/how-to-encrypt-jwt-security-token
        //        var tokenHandler = new JwtSecurityTokenHandler();

        //        //create a identity and add claims to the user which we want to log in
        //        ClaimsIdentity claimsIdentity = new ClaimsIdentity(new[]
        //        {
        //            new Claim(ClaimTypes.Name, username)
        //        });

        //        const string sec = "401b09eab3c013d4ca54922bb802bec8fd5318192b0a75f201d8b3727429090fb337591abd3e44453b954555b7a0812e1081c39b740293f765eae731f5a65ed1";
        //        var now = DateTime.UtcNow;
        //        var securityKey = new Microsoft.IdentityModel.Tokens.SymmetricSecurityKey(System.Text.Encoding.Default.GetBytes(sec));
        //        var signingCredentials = new Microsoft.IdentityModel.Tokens.SigningCredentials(securityKey, Microsoft.IdentityModel.Tokens.SecurityAlgorithms.HmacSha256Signature);


        //        //create the jwt
        //        var token =
        //            (JwtSecurityToken)
        //                tokenHandler.CreateJwtSecurityToken(issuer: "http://localhost:50191", audience: "http://localhost:50191",
        //                    subject: claimsIdentity, notBefore: issuedAt, expires: expires, signingCredentials: signingCredentials);
        //        var tokenString = tokenHandler.WriteToken(token);

        //        return tokenString;
        //    }


    }



}
