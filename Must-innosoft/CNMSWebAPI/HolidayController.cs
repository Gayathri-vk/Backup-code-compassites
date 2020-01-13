using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using System.IdentityModel.Tokens.Jwt;
using JWT;
using System.Web;
using CNMSDataAccess;
namespace CNMSWebAPI.Controllers
{
    public class HolidayController : ApiController
    {
        string message = "";
        Boolean status = true;
        HttpContext httpContext = HttpContext.Current;
        int clientid = 0;

        public HttpResponseMessage Get()
        {
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {


                try
                {
                    GetTokenClientId();
                }
                catch (TokenExpiredException ex)
                {
                    return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
                }
                catch (SignatureVerificationException ex)
                {
                    return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);

                }

                ent.Configuration.ProxyCreationEnabled = false;

                if (clientid == 0)
                {
                    var dat = (from c in ent.HolidayMasters
                               select new
                               {
                                   
                                   c.Client.ClientName,
                                   c.ClientId,
                                   

                                   c.HId,
                                   c.HolidayDate,
                                   c.HolidayName,
                                   c.Status
                                   
                               }).ToList();

                    return Request.CreateResponse(HttpStatusCode.OK, dat);
                }
                else
                {
                    var dat = (from c in ent.HolidayMasters
                               where c.ClientId == clientid
                               select new
                               {
                                   c.Client.ClientName,
                                   c.ClientId,


                                   c.HId,
                                   c.HolidayDate,
                                   c.HolidayName,
                                   c.Status
                               }).ToList();

                    return Request.CreateResponse(HttpStatusCode.OK, dat);
                }
            }
        }
        private void GetTokenClientId()
        {

            string authHeader = this.httpContext.Request.Headers["Authorization"];

            var authBits = authHeader.Split(' ');
            var tokenHandler = new JwtSecurityTokenHandler();

            var readableToken = tokenHandler.CanReadToken(authBits[1].ToString());
            if (readableToken == true)
            {
                var jwtToken = tokenHandler.ReadToken(authBits[1]) as JwtSecurityToken;

                var cli = jwtToken.Payload.ToList();
                if (cli.Count > 0)
                {
                    string val = cli[2].ToString().Replace("[", "").Replace("]", "");
                    string spli = val.Split(',')[1];
                    clientid = Convert.ToInt32(spli);
                }


            }
            
        }
        public HttpResponseMessage Post([FromBody] HolidayMaster UserDet)
        {
            try
            {
                string authHeader = this.httpContext.Request.Headers["Authorization"];
                clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;

                    DateTime upDate = DateTime.Now;
                    DateTime hdate = new DateTime(UserDet.HolidayDate.Value.Year, UserDet.HolidayDate.Value.Month, UserDet.HolidayDate.Value.Day, 0, 0, 0);
                    var dat2 = ent.HolidayMasters.FirstOrDefault(c => c.HId == UserDet.HId);
                    if (dat2 == null)
                    {
                        var dat = ent.HolidayMasters.FirstOrDefault(c => c.ClientId == UserDet.ClientId && c.HolidayDate == hdate);
                        if (dat == null)
                        {



                            UserDet.HolidayDate = hdate;
                            ent.HolidayMasters.Add(UserDet);
                            ent.SaveChanges();



                            message = "Saved Successfully";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });

                        }
                        else
                        {
                            status = false;
                            message = "Holiday Date " + UserDet.HolidayDate.ToString() + " already exists";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                    }
                    else
                    {
                        var dat1 = ent.HolidayMasters.FirstOrDefault(c => c.ClientId == UserDet.ClientId && c.HolidayDate == hdate);

                        var dat = ent.HolidayMasters.FirstOrDefault(c => c.HId == UserDet.HId);
                        if (dat1 == null)
                        {
                            if (dat != null)
                            {

                                dat.ClientId = UserDet.ClientId;


                                dat.HolidayDate = hdate;
                                dat.HolidayName = UserDet.HolidayName;
                                
                                dat.Status = UserDet.Status;

                                ent.SaveChanges();



                                message = "Updated Successfully";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {

                                message = "Holiday with id = " + UserDet.HId.ToString() + " not found";
                                return Request.CreateErrorResponse(HttpStatusCode.NotFound, message);

                            }
                        }
                        else
                        {
                            if (dat.HId != dat1.HId)
                            {
                                status = false;
                                message = "Holiday Date " + UserDet.HolidayDate.ToString() + " already exists";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {
                                dat.ClientId = UserDet.ClientId;
                                
                                dat.HolidayDate = hdate;
                                dat.HolidayName = UserDet.HolidayName;

                                dat.Status = UserDet.Status;


                                ent.SaveChanges();
                                message = "Updated Successfully";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                        }
                    }


                }
            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
        }
    }
}
