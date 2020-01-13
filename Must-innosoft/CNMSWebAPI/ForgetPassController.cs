using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CNMSDataAccess;

namespace CNMSWebAPI.Controllers
{
    public class ForgetPassController : ApiController
    {
        [HttpPost]
        public HttpResponseMessage Authenticate([FromBody] Forgetpassword login)
        {
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                string message = "";
                Boolean status = true;
                ent.Configuration.ProxyCreationEnabled = false;
                var dat = ent.UserDetails.FirstOrDefault(c => c.ClientCode == login.ClientCode && c.User_Role_Id == 2 );
                if (dat == null)
                {
                    message = "User ClientCode does not exists";
                    status = false;
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                }
                else
                {
                    var dat1 = (from c  in ent.Clients where c.ClientCode == login.ClientCode && c.EmailId == login.Email select c).FirstOrDefault();
                    if (dat1 == null)
                    {
                        message = "User details does not exists";
                        status = false;
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    }
                    else {

                        UserPassReset nu = new UserPassReset();
                        nu.UserId = dat.UserId;
                        nu.Password = dat.Password;
                        nu.Up_Date = DateTime.Now;
                        ent.UserPassResets.Add(nu);
                        ent.SaveChanges();

                        dat.Password = "XEGN178";
                        ent.UserDetails.Add(dat);
                        ent.SaveChanges();


                        message = "User Password is reseted..Your new password is - XEGN178";
                        status = true;
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    }
                    }
                }
                
            }

        }
        public partial class Forgetpassword
        {
            public string ClientCode { get; set; }
            public string Email { get; set; }
        }
        

}
