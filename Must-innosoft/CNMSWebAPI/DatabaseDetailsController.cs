using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CNMSDataAccess;
using System.Data.Entity;

namespace CNMSWebAPI.Controllers
{
    public class DatabaseDetailsController : ApiController
    {
        string message = "";
        Boolean status = true;
        public HttpResponseMessage Get()
        {

            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                //return ent.DatabaseDetails.ToList();
                var dat = (from c in ent.DatabaseDetails
                           select new
                           {
                               c.Client.ClientName,
                               c.ClientId,
                               c.Company.CompanyName,
                               c.CompanyId,
                               c.DatabaseId,
                               c.DB_Name,
                               c.DB_Password,
                               c.DB_Username,
                               c.Server_Name,
                               c.Status
                           }).ToList();
                return Request.CreateResponse(HttpStatusCode.OK, dat);
            }
        }
        public HttpResponseMessage Get(int id)
        {
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                var dat = ent.DatabaseDetails.FirstOrDefault(c => c.DatabaseId == id);
                if (dat != null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, dat);

                }
                else
                {
                    message = "DatabaseDetails with id = " + id.ToString() + " not found";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });

                }
            }
        }
        public HttpResponseMessage Post([FromBody] DatabaseDetail DBDet)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    var dat2 = ent.DatabaseDetails.FirstOrDefault(c => c.DatabaseId == DBDet.DatabaseId);
                    if (dat2 == null)
                    { 
                    var dat = ent.DatabaseDetails.FirstOrDefault(c => c.DB_Name == DBDet.DB_Name);
                    if (dat != null)
                    {
                        ent.DatabaseDetails.Add(DBDet);
                        ent.SaveChanges();
                        message = "Saved Successfully";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        //var message = Request.CreateResponse(HttpStatusCode.Created, Countrys);
                        //message.Headers.Location = new Uri(Request.RequestUri + "/" + Countrys.CountryId.ToString());
                        //return message;
                    }
                    else
                    {
                        message = "Database Name " + DBDet.DB_Name.ToString() + " already exists";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    }
                }
                else
                    {
                        var dat1 = ent.DatabaseDetails.FirstOrDefault(c => c.DB_Name == DBDet.DB_Name);

                        var dat = ent.DatabaseDetails.FirstOrDefault(c => c.DatabaseId == DBDet.DatabaseId);
                        if (dat1 == null)
                        {
                            if (dat != null)
                            {

                                dat.ClientId = DBDet.ClientId;
                                dat.CompanyId = DBDet.CompanyId;
                                dat.Server_Name = DBDet.Server_Name;
                                dat.DB_Name = DBDet.DB_Name;
                                dat.DB_Password = DBDet.DB_Password;
                                dat.DB_Username = DBDet.DB_Username;
                                dat.Status = DBDet.Status;
                                ent.SaveChanges();
                                message = "Updated Successfully";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {
                                message = "DatabaseDetails with id = " + DBDet.DatabaseId.ToString() + " not found";
                                return Request.CreateErrorResponse(HttpStatusCode.NotFound, message);

                            }
                        }
                        else
                        {
                            if (dat.DatabaseId != dat.DatabaseId)
                            {
                                message = "Database Name " + dat1.DB_Name.ToString() + " already exists";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {
                                dat.ClientId = DBDet.ClientId;
                                dat.CompanyId = DBDet.CompanyId;
                                dat.Server_Name = DBDet.Server_Name;
                                dat.DB_Name = DBDet.DB_Name;
                                dat.DB_Password = DBDet.DB_Password;
                                dat.DB_Username = DBDet.DB_Username;
                                dat.Status = DBDet.Status;

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

        public HttpResponseMessage Put(int id, [FromBody] DatabaseDetail DBDet)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    var dat1 = ent.DatabaseDetails.FirstOrDefault(c => c.DB_Name == DBDet.DB_Name);

                    var dat = ent.DatabaseDetails.FirstOrDefault(c => c.DatabaseId == id);
                    if (dat1 == null)
                    {
                        if (dat != null)
                        {

                            dat.ClientId = DBDet.ClientId;
                            dat.CompanyId = DBDet.CompanyId;
                            dat.Server_Name = DBDet.Server_Name;
                            dat.DB_Name = DBDet.DB_Name;
                            dat.DB_Password = DBDet.DB_Password;
                            dat.DB_Username = DBDet.DB_Username;
                            dat.Status = DBDet.Status;
                            ent.SaveChanges();
                            message = "Updated Successfully";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                        else
                        {
                            message = "DatabaseDetails with id = " + id.ToString() + " not found";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });

                        }
                    }
                    else
                    {
                        if (dat.DatabaseId != dat.DatabaseId)
                        {
                            message = "Database Name " + dat1.DB_Name.ToString() + " already exists";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                        else
                        {
                            dat.ClientId = DBDet.ClientId;
                            dat.CompanyId = DBDet.CompanyId;
                            dat.Server_Name = DBDet.Server_Name;
                            dat.DB_Name = DBDet.DB_Name;
                            dat.DB_Password = DBDet.DB_Password;
                            dat.DB_Username = DBDet.DB_Username;
                            dat.Status = DBDet.Status;
                            
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
