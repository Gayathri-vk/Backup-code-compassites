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
    public class SupplierController : ApiController
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
                    var dat = (from c in ent.SupplierMasters
                               select new
                               {
                                   CompanyName = (from a in ent.Clients join m in ent.Companies on a.CompanyId equals m.CompanyId where a.ClientId == c.ClientId select m.CompanyName).DefaultIfEmpty("").FirstOrDefault(),
                                   c.Client.ClientName,
                                   c.ClientId,
                                   CompanyId = (from a in ent.Clients join m in ent.Companies on a.CompanyId equals m.CompanyId where a.ClientId == c.ClientId select m.CompanyId).DefaultIfEmpty(0).FirstOrDefault(),

                                   c.ContactNo,
                                   c.ContactPerson,
                                   c.EmailId,
                                   c.SupplierAddress,
                                   c.Status,
                                   c.SupplierId,
                                   c.SupplierName,
                                   c.Type
                               }).ToList();

                    return Request.CreateResponse(HttpStatusCode.OK, dat);
                }
                else
                {
                    var dat = (from c in ent.SupplierMasters
                               where c.ClientId == clientid
                               select new
                               {
                                   CompanyName = (from a in ent.Clients join m in ent.Companies on a.CompanyId equals m.CompanyId where a.ClientId == c.ClientId select m.CompanyName).DefaultIfEmpty("").FirstOrDefault(),
                                   c.Client.ClientName,
                                   c.ClientId,
                                   CompanyId = (from a in ent.Clients join m in ent.Companies on a.CompanyId equals m.CompanyId where a.ClientId == c.ClientId select m.CompanyId).DefaultIfEmpty(0).FirstOrDefault(),

                                   c.ContactNo,
                                   c.ContactPerson,
                                   c.EmailId,
                                   c.SupplierAddress,
                                   c.Status,
                                   c.SupplierId,
                                   c.SupplierName,
                                   c.Type
                               }).ToList();

                    return Request.CreateResponse(HttpStatusCode.OK, dat);
                }
            }
        }
        public HttpResponseMessage Get(int id)
        {
            string authHeader = this.httpContext.Request.Headers["Authorization"];
            clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                if (id == 1)
                {
                    var dat = (from c in ent.SupplierMasters
                               where c.ClientId == clientid && c.Type == "Supplier"
                               select new
                               {
                                   CompanyName = (from a in ent.Clients join m in ent.Companies on a.CompanyId equals m.CompanyId where a.ClientId == c.ClientId select m.CompanyName).DefaultIfEmpty("").FirstOrDefault(),
                                   c.Client.ClientName,
                                   c.ClientId,
                                   CompanyId = (from a in ent.Clients join m in ent.Companies on a.CompanyId equals m.CompanyId where a.ClientId == c.ClientId select m.CompanyId).DefaultIfEmpty(0).FirstOrDefault(),

                                   c.ContactNo,
                                   c.ContactPerson,
                                   c.EmailId,
                                   c.SupplierAddress,
                                   c.Status,
                                   c.SupplierId,
                                   c.SupplierName,
                                   c.Type
                               }).ToList();

                    return Request.CreateResponse(HttpStatusCode.OK, dat);
                }
                else
                {
                    
                        var dat = (from c in ent.SupplierMasters
                                   where c.ClientId == clientid && c.Type != "Supplier"
                                   select new
                                   {
                                       CompanyName = (from a in ent.Clients join m in ent.Companies on a.CompanyId equals m.CompanyId where a.ClientId == c.ClientId select m.CompanyName).DefaultIfEmpty("").FirstOrDefault(),
                                       c.Client.ClientName,
                                       c.ClientId,
                                       CompanyId = (from a in ent.Clients join m in ent.Companies on a.CompanyId equals m.CompanyId where a.ClientId == c.ClientId select m.CompanyId).DefaultIfEmpty(0).FirstOrDefault(),

                                       c.ContactNo,
                                       c.ContactPerson,
                                       c.EmailId,
                                       c.SupplierAddress,
                                       c.Status,
                                       c.SupplierId,
                                       c.SupplierName,
                                       c.Type
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

        public HttpResponseMessage Post([FromBody] SupplierMaster UserDet)
        {
            try
            {
                string authHeader = this.httpContext.Request.Headers["Authorization"];
                clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;

                    DateTime upDate = DateTime.Now;

                    var dat2 = ent.SupplierMasters.FirstOrDefault(c => c.SupplierId == UserDet.SupplierId);
                    if (dat2 == null)
                    {
                        var dat = ent.SupplierMasters.FirstOrDefault(c => c.ClientId == UserDet.ClientId && c.SupplierName == UserDet.SupplierName);
                        if (dat == null)
                        {


                            
                            UserDet.Modfied_Date = upDate;
                            ent.SupplierMasters.Add(UserDet);
                            ent.SaveChanges();

                            

                            message = "Saved Successfully";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            
                        }
                        else
                        {
                            status = false;
                            message = "Supplier Name " + UserDet.SupplierName.ToString() + " already exists";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                    }
                    else
                    {
                        var dat1 = ent.SupplierMasters.FirstOrDefault(c => c.ClientId == UserDet.ClientId && c.SupplierName == UserDet.SupplierName);

                        var dat = ent.SupplierMasters.FirstOrDefault(c => c.SupplierId == UserDet.SupplierId);
                        if (dat1 == null)
                        {
                            if (dat != null)
                            {

                                dat.ClientId = UserDet.ClientId;
                                
                                
                                dat.Type = UserDet.Type;
                                dat.SupplierName = UserDet.SupplierName;
                                dat.SupplierAddress = UserDet.SupplierAddress;
                                dat.EmailId = UserDet.EmailId;
                                dat.ContactPerson = UserDet.ContactPerson;
                                
                                dat.Modfied_Date = DateTime.Now;
                                dat.ContactNo = UserDet.ContactNo;

                                

                                dat.Status = UserDet.Status;
                                
                                ent.SaveChanges();



                                message = "Updated Successfully";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {

                                message = "Supplier with id = " + UserDet.SupplierId.ToString() + " not found";
                                return Request.CreateErrorResponse(HttpStatusCode.NotFound, message);

                            }
                        }
                        else
                        {
                            if (dat.SupplierId != dat1.SupplierId)
                            {
                                status = false;
                                message = "Supplier Name " + UserDet.SupplierName.ToString() + " already exists";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {
                                dat.ClientId = UserDet.ClientId;


                                dat.Type = UserDet.Type;
                                dat.SupplierName = UserDet.SupplierName;
                                dat.SupplierAddress = UserDet.SupplierAddress;
                                dat.EmailId = UserDet.EmailId;
                                dat.ContactPerson = UserDet.ContactPerson;

                                dat.Modfied_Date = DateTime.Now;
                                dat.ContactNo = UserDet.ContactNo;



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
