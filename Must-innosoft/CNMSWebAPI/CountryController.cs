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
    
    public class CountryController : ApiController
    {
        

        string message = "";
        Boolean status = true;
        public IEnumerable<Country> Get()
        {

            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                return ent.Countries.ToList();
            }
        }
        public HttpResponseMessage Get(int id)
        {
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                var dat = ent.Countries.FirstOrDefault(c => c.CountryId == id);
                if (dat != null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, dat);

                }
                else
                {
                    message = "Country with id = " + id.ToString() + " not found";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    
                }
            }
        }
        public HttpResponseMessage Post([FromBody] Country Countrys)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    var dat2 = ent.Countries.FirstOrDefault(c => c.CountryId == Countrys.CountryId);
                    if (dat2 == null)
                    {
                        var dat = ent.Countries.FirstOrDefault(c => c.Country_Name == Countrys.Country_Name);
                        if (dat == null)
                        {
                            ent.Countries.Add(Countrys);
                            ent.SaveChanges();
                            message = "Saved Successfully";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            //var message = Request.CreateResponse(HttpStatusCode.Created, Countrys);
                            //message.Headers.Location = new Uri(Request.RequestUri + "/" + Countrys.CountryId.ToString());
                            //return message;
                        }
                        else
                        {
                            message = "Country " + Countrys.Country_Name.ToString() + " already exists";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                    }
                    else
                    {
                        var dat1 = ent.Countries.FirstOrDefault(c => c.Country_Name == Countrys.Country_Name);

                        var dat = ent.Countries.FirstOrDefault(c => c.CountryId == Countrys.CountryId);
                        if (dat1 == null)
                        {
                            if (dat != null)
                            {

                                dat.Country_Code = Countrys.Country_Code;
                                dat.Country_Currency = Countrys.Country_Currency;
                                dat.Country_Name = Countrys.Country_Name;
                                dat.Country_TimeZone = Countrys.Country_TimeZone;

                                dat.Status = Countrys.Status;
                                ent.SaveChanges();
                                message = "Updated Successfully";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {
                                message = "Country with id = " + Countrys.CountryId.ToString() + " not found";
                                //return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                return Request.CreateErrorResponse(HttpStatusCode.NotFound,  message);
                            }
                        }
                        else
                        {
                            if (dat.CountryId != dat.CountryId)
                            {
                                message = "Country " + dat1.Country_Name.ToString() + " already exists";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            else
                            {
                                dat.Country_Code = Countrys.Country_Code;
                                dat.Country_Currency = Countrys.Country_Currency;
                                dat.Country_Name = Countrys.Country_Name;
                                dat.Country_TimeZone = Countrys.Country_TimeZone;

                                dat.Status = Countrys.Status;
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

        public HttpResponseMessage Put(int id, [FromBody] Country Countrys)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    var dat1 = ent.Countries.FirstOrDefault(c => c.Country_Name == Countrys.Country_Name);

                    var dat = ent.Countries.FirstOrDefault(c => c.CountryId == id);
                    if (dat1 == null)
                    {
                        if (dat != null)
                        {

                            dat.Country_Code = Countrys.Country_Code;
                            dat.Country_Currency = Countrys.Country_Currency;
                            dat.Country_Name = Countrys.Country_Name;
                            dat.Country_TimeZone = Countrys.Country_TimeZone;

                            dat.Status = Countrys.Status;
                            ent.SaveChanges();
                            message = "Updated Successfully";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                        else
                        {
                            message = "Country with id = " + id.ToString() + " not found";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });

                        }
                    }
                    else
                    {
                        if (dat.CountryId != dat.CountryId)
                        {
                            message = "Country " + dat1.Country_Name.ToString() + " already exists";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        }
                        else
                        {
                            dat.Country_Code = Countrys.Country_Code;
                            dat.Country_Currency = Countrys.Country_Currency;
                            dat.Country_Name = Countrys.Country_Name;
                            dat.Country_TimeZone = Countrys.Country_TimeZone;

                            dat.Status = Countrys.Status;
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
