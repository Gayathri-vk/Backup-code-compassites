using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CNMSDataAccess;
using System.Data.Entity;
using System.IdentityModel.Tokens.Jwt;
using JWT;
using System.Web;

namespace CNMSWebAPI.Controllers
{
    public class UserDetailsController : ApiController
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
                //return ent.UserDetails.ToList();
                if(clientid==0)
                { 
                var dat = (from c in ent.UserDetails
                           select new
                           {
                               c.Company.CompanyName,
                               c.Client.ClientName,
                               c.ClientId,
                               c.CompanyId,
                               c.ClientCode,
                               c.ExprieDate,
                               c.MaintanceDate, c.Password, c.Status, c.UserId, c.Username, c.User_Role_Id,c.UserRole.Role_Name,
                               c.Loginuser,
                               c.Designation,
                               c.Type,
                               c.SupplierId
                           }).ToList();

                return Request.CreateResponse(HttpStatusCode.OK, dat);
                }
                else
                {
                    var dat = (from c in ent.UserDetails
                               where c.ClientId == clientid
                               select new
                               {
                                   c.Company.CompanyName,
                                   c.Client.ClientName,
                                   c.ClientId,
                                   c.CompanyId,
                                   c.ClientCode,
                                   c.ExprieDate,
                                   c.MaintanceDate,
                                   c.Password,
                                   c.Status,
                                   c.UserId,
                                   c.Username,
                                   c.User_Role_Id,
                                   c.UserRole.Role_Name,
                                   c.Loginuser,
                                   c.Designation,
                                   c.Type,
                    c.SupplierId
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
        public HttpResponseMessage Get(int id)
        {
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                if(id!=0)
                { 
                var dat = ent.UserDetails.FirstOrDefault(c => c.UserId == id);
                if (dat != null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, dat);

                }
                else
                {
                    message = "UserDetails with id = " + id.ToString() + " not found";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });

                }
                }
                else
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
                    if (clientid == 0)
                    {
                        var dat = ent.UserRoles.Where(c => c.Status == 1).ToList();
                        if (dat != null)
                        {
                            return Request.CreateResponse(HttpStatusCode.OK, dat);

                        }
                        else
                        {
                            message = "UserRoles details does not found";
                            return Request.CreateErrorResponse(HttpStatusCode.NotFound, message);

                        }

                    }
                    else
                    {
                        var dat = ent.UserRoles.Where(c => c.Status == 1 && c.User_RoleId != 1 && c.User_RoleId != 8).ToList();
                        if (dat != null)
                        {
                            return Request.CreateResponse(HttpStatusCode.OK, dat);

                        }
                        else
                        {
                            message = "UserRoles details does not found";
                            return Request.CreateErrorResponse(HttpStatusCode.NotFound, message);

                        }
                    }
                }
            }
        }
        public HttpResponseMessage Post([FromBody] UserDetail UserDet)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    string ClientCode = "";
                    DateTime ExprieDate = DateTime.Now;
                    int usercont = 0;
                    var clicod = ent.Clients.Where(c => c.ClientId == UserDet.ClientId).FirstOrDefault();
                    if (clicod != null)
                    {
                        ClientCode = clicod.ClientCode;
                        ExprieDate = (DateTime)clicod.ExprieDate;
                        if (clicod.NoofUser != 0)
                        {
                            usercont = Convert.ToInt32(clicod.NoofUser);
                            var ucount = (from a in ent.UserDetails where a.ClientId == UserDet.ClientId select a.ClientId).Count();

                            if (ucount >= usercont)
                            {
                                status = false;
                                message = "User Creation Not Possible ,You have exceeded your limit";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                        }
                    }
                    var dat2 = ent.UserDetails.FirstOrDefault(c => c.UserId == UserDet.UserId);
                    if (dat2 == null)
                    {
                        var dat = ent.UserDetails.FirstOrDefault(c => c.ClientCode == ClientCode && c.Username == UserDet.Username);
                        if (dat == null)
                        {
                            

                            UserDet.ClientCode = ClientCode;
                            UserDet.ExprieDate = ExprieDate;
                            ent.UserDetails.Add(UserDet);
                            ent.SaveChanges();

                            var getid = (from a in ent.UserDetails select a.UserId).Max();

                            UserValidity s = new UserValidity();
                            s.ClientId = (long)UserDet.ClientId;
                            s.ExprieDate = ExprieDate;
                            s.MaintanceDate = UserDet.MaintanceDate;
                            s.UserId = (long)getid;
                            ent.UserValidities.Add(s);
                            
                            ent.SaveChanges();

                            if (UserDet.User_Role_Id == 2)
                            {
                                var getmenu = (from a in ent.MenuDetails where a.MID!=3 && a.MID!=4 && a.MID!=8 select a.MID).ToList();
                                foreach (var item in getmenu)
                                {
                                    var uar = (from a in ent.UserRoleMenus where a.ClientId == s.ClientId && a.User_RoleId == 2 && a.MID == item select a).FirstOrDefault();
                                    if (uar == null)
                                    {
                                        UserRoleMenu u = new UserRoleMenu();
                                        u.ClientId = s.ClientId;
                                        u.CompanyId = UserDet.CompanyId;
                                        u.MID = item;
                                        u.User_RoleId = 2;
                                        u.Status = 1;
                                        ent.UserRoleMenus.Add(u);
                                        ent.SaveChanges();
                                    }
                                }

                            }

                            message = "Saved Successfully";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            //var message = Request.CreateResponse(HttpStatusCode.Created, Countrys);
                            //message.Headers.Location = new Uri(Request.RequestUri + "/" + Countrys.CountryId.ToString());
                            //return message;
                        }
                        else
                        {
                            status = false;
                            message = "UserDetail Name " + UserDet.Username.ToString() + " already exists";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                    }
                    else
                    {
                        var dat1 = ent.UserDetails.FirstOrDefault(c => c.ClientCode == UserDet.ClientCode && c.Username == UserDet.Username);

                        var dat = ent.UserDetails.FirstOrDefault(c => c.UserId == UserDet.UserId);
                        if (dat1 == null)
                        {
                            if (dat != null)
                            {

                                dat.ClientId = UserDet.ClientId;
                                //dat.CompanyId = UserDet.CompanyId;
                                dat.ClientCode = ClientCode;
                                dat.CreateDate = UserDet.CreateDate;
                                dat.Created_by = UserDet.Created_by;
                                dat.ExprieDate = ExprieDate;
                                dat.Loginuser = UserDet.Loginuser;
                                dat.Designation = UserDet.Designation;
                                //dat.MaintanceDate = UserDet.MaintanceDate;
                                dat.Modfied_Date = DateTime.Now;
                                dat.Modified_by = UserDet.Modified_by;
                                dat.Type = UserDet.Type;
                                dat.SupplierId = UserDet.SupplierId;
                                dat.Password = UserDet.Password;
                                dat.Username = UserDet.Username;
                                dat.User_Role_Id = UserDet.User_Role_Id;

                                dat.Status = UserDet.Status;
                                var chk = ent.UserValidities.FirstOrDefault(c => c.UserId == dat.UserId && c.MaintanceDate == dat.MaintanceDate && c.ExprieDate == dat.ExprieDate);
                                if (chk == null)
                                {
                                    UserValidity s = new UserValidity();
                                    s.ClientId = (long)UserDet.ClientId;
                                    s.ExprieDate = ExprieDate;
                                    s.MaintanceDate = UserDet.MaintanceDate;
                                    s.UserId = dat.UserId;
                                    ent.UserValidities.Add(s);
                                }
                                ent.SaveChanges();



                                message = "Updated Successfully";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {

                                message = "UserDetails with id = " + UserDet.UserId.ToString() + " not found";
                                return Request.CreateErrorResponse(HttpStatusCode.NotFound, message);

                            }
                        }
                        else
                        {
                            if (dat.UserId != dat1.UserId)
                            {
                                status = false;
                                message = "UserDetail Name " + UserDet.Username.ToString() + " already exists";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {
                                dat.ClientId = UserDet.ClientId;
                                //dat.CompanyId = UserDet.CompanyId;
                                dat.ClientCode = ClientCode;
                                dat.CreateDate = UserDet.CreateDate;
                                dat.Created_by = UserDet.Created_by;
                                dat.ExprieDate = ExprieDate;
                                dat.Loginuser = UserDet.Loginuser;
                                dat.Designation = UserDet.Designation;
                                dat.MaintanceDate = UserDet.MaintanceDate;
                                dat.Modfied_Date = DateTime.Now;
                                dat.Modified_by = UserDet.Modified_by;
                                dat.Type = UserDet.Type;
                                dat.SupplierId = UserDet.SupplierId;
                                dat.Password = UserDet.Password;
                                dat.Username = UserDet.Username;
                                dat.User_Role_Id = UserDet.User_Role_Id;

                                dat.Status = UserDet.Status;
                                var chk = ent.UserValidities.FirstOrDefault(c => c.UserId == dat.UserId && c.MaintanceDate == dat.MaintanceDate && c.ExprieDate == dat.ExprieDate);
                                if (chk == null)
                                {
                                    UserValidity s = new UserValidity();
                                    s.ClientId = (long)UserDet.ClientId;
                                    s.ExprieDate = ExprieDate;
                                    s.MaintanceDate = UserDet.MaintanceDate;
                                    s.UserId = dat.UserId;
                                    ent.UserValidities.Add(s);
                                }
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

        public HttpResponseMessage Put(int id, [FromBody] UserDetail UserDet)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    var dat1 = ent.UserDetails.FirstOrDefault(c => c.ClientCode == UserDet.ClientCode && c.Username == UserDet.Username);

                    var dat = ent.UserDetails.FirstOrDefault(c => c.UserId == id);
                    if (dat1 == null)
                    {
                        if (dat != null)
                        {

                            //dat.ClientId = UserDet.ClientId;
                            //dat.CompanyId = UserDet.CompanyId;
                            dat.ClientCode = UserDet.ClientCode;
                            dat.CreateDate = UserDet.CreateDate;
                            dat.Created_by = UserDet.Created_by;
                            dat.ExprieDate = UserDet.ExprieDate;

                            dat.MaintanceDate = UserDet.MaintanceDate;
                            dat.Modfied_Date = DateTime.Now;
                            dat.Modified_by = UserDet.Modified_by;
                            dat.Loginuser = UserDet.Loginuser;
                            dat.Designation = UserDet.Designation;
                            dat.Password = UserDet.Password;
                            dat.Username = UserDet.Username;
                            dat.User_Role_Id = UserDet.User_Role_Id;
                            
                            dat.Status = UserDet.Status;
                            var chk = ent.UserValidities.FirstOrDefault(c => c.UserId == dat.UserId && c.MaintanceDate == dat.MaintanceDate && c.ExprieDate == dat.ExprieDate);
                            if (chk == null)
                            {
                                UserValidity s = new UserValidity();
                                s.ClientId = (long)UserDet.ClientId;
                                s.ExprieDate = UserDet.ExprieDate;
                                s.MaintanceDate = UserDet.MaintanceDate;
                                s.UserId = dat.UserId;
                                ent.UserValidities.Add(s);
                            }
                            ent.SaveChanges();



                            message = "Updated Successfully";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                        else
                        {
                            message = "UserDetails with id = " + id.ToString() + " not found";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });

                        }
                    }
                    else
                    {
                        if (dat.UserId != dat.UserId)
                        {
                            message = "UserDetail Name " + UserDet.Username.ToString() + " already exists";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                        else
                        {
                            //dat.ClientId = UserDet.ClientId;
                            //dat.CompanyId = UserDet.CompanyId;
                            //dat.ClientCode = UserDet.ClientCode;
                            dat.CreateDate = UserDet.CreateDate;
                            dat.Created_by = UserDet.Created_by;
                            dat.ExprieDate = UserDet.ExprieDate;
                            dat.Loginuser = UserDet.Loginuser;
                            dat.Designation = UserDet.Designation;
                            dat.MaintanceDate = UserDet.MaintanceDate;
                            dat.Modfied_Date = DateTime.Now;
                            dat.Modified_by = UserDet.Modified_by;

                            dat.Password = UserDet.Password;
                            dat.Username = UserDet.Username;
                            dat.User_Role_Id = UserDet.User_Role_Id;

                            dat.Status = UserDet.Status;
                            var chk = ent.UserValidities.FirstOrDefault(c => c.UserId == dat.UserId && c.MaintanceDate == dat.MaintanceDate && c.ExprieDate == dat.ExprieDate);
                            if (chk == null)
                            {
                                UserValidity s = new UserValidity();
                                s.ClientId = (long)UserDet.ClientId;
                                s.ExprieDate = UserDet.ExprieDate;
                                s.MaintanceDate = UserDet.MaintanceDate;
                                s.UserId = dat.UserId;
                                ent.UserValidities.Add(s);
                            }
                            ent.SaveChanges();
                            message = "Updated Successfully";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
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
