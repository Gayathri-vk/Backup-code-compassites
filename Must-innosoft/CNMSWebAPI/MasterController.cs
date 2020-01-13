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
    public class MasterController : ApiController
    {
        //Get Method 3
        //GetURL  "/api/master?CName=all"
        //public HttpResponseMessage Get(string CName = "All")
        //{

        //    using (ConstructionDBEntities ent = new ConstructionDBEntities())
        //    {
        //        ent.Configuration.ProxyCreationEnabled = false;
        //        switch (CName.ToLower())
        //        {
        //            case "all":
        //                return Request.CreateResponse(HttpStatusCode.OK, ent.Companies.ToList());
        //            default:
        //                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, "Given " + CName + " is invalid");

        //        }
        //    }
        //}

        //Get Method 2
        //Custom Method Creation
        //[HttpGet]
        //public IEnumerable<Company> LoadCompany()
        public IEnumerable<Company> Get()
        {

            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                return ent.Companies.ToList();
            }
        }
        //Get Method 2
        //public Company Get(int id)
        //{
        //    using (ConstructionDBEntities ent = new ConstructionDBEntities())
        //    {
        //        ent.Configuration.ProxyCreationEnabled = false;
        //        return ent.Companies.FirstOrDefault(c=>c.CompanyId == id);
        //    }
        //}
        public HttpResponseMessage Get(int id)
        {
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                var dat= ent.Companies.FirstOrDefault(c => c.CompanyId == id);
                if (dat != null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, dat);
               
                }
                else
                {
                    return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Company with id = " + id.ToString() + " not found");
                }
            }
        }
        //public void Post([FromBody] Company company)
        //{
        //    using (ConstructionDBEntities ent = new ConstructionDBEntities())
        //    {
        //            ent.Configuration.ProxyCreationEnabled = false;

        //            ent.Companies.Add(company);
        //            ent.SaveChanges();

        //    }
        //}
        public HttpResponseMessage Post([FromBody] Company company)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;

                    ent.Companies.Add(company);
                    ent.SaveChanges();

                    var message = Request.CreateResponse(HttpStatusCode.Created, company);
                    message.Headers.Location = new Uri(Request.RequestUri +"/"+ company.CompanyId.ToString());
                    return message;
                }
            }
            catch(Exception ex) {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
        }
        //public void Delete(int id)
        //{
        //    using (ConstructionDBEntities ent = new ConstructionDBEntities())
        //    {
        //        ent.Configuration.ProxyCreationEnabled = false;
        //        ent.Companies.Remove(ent.Companies.FirstOrDefault(c => c.CompanyId == id));
        //        ent.SaveChanges();
        //    }
        //}
        public HttpResponseMessage Delete(int id)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    var dat = ent.Companies.FirstOrDefault(c => c.CompanyId == id);
                    if (dat != null)
                    {
                        ent.Companies.Remove(dat);
                        ent.SaveChanges();
                        return Request.CreateResponse(HttpStatusCode.OK);
                    }
                    else
                    {
                        return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Company with id = " + id.ToString() + " not found to delete");
                    }
                }
            }

            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
        }
        //public void Put(int id, [FromBody] Company company)
        //{
        //    using (ConstructionDBEntities ent = new ConstructionDBEntities())
        //    {
        //        ent.Configuration.ProxyCreationEnabled = false;
        //        var dat = ent.Companies.FirstOrDefault(c => c.CompanyId == id);
        //        dat.CompanyName = company.CompanyName;
        //        dat.AuthorisedPerson = company.AuthorisedPerson;
        //        dat.City = company.City;
        //        dat.Country = company.Country;
        //        dat.EmailId = company.EmailId;
        //        dat.GSTNo = company.GSTNo;
        //        dat.HandPhoneNo = company.HandPhoneNo;
        //        dat.Pincode = company.Pincode;
        //        dat.StateCode = company.StateCode;
        //        dat.Street = company.Street;
        //        dat.State = company.State;
        //            dat.TaxNo = company.TaxNo;
        //        dat.TelePhoneNo = company.TelePhoneNo;
        //        dat.UintNo = company.UintNo;
        //        dat.Website = company.Website;
        //        ent.SaveChanges();
        //    }
        //}
        //Put Uri /api/master/1 or /api/master?id=1&CompanyName=Con
        //public HttpResponseMessage Put(int id, [FromUri] Company company)

        //Put Uri /api/master?CompanyName=Con1
        //public HttpResponseMessage Put([FromBody]int id, [FromUri] Company company)
        public HttpResponseMessage Put(int id, [FromBody] Company company)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    var dat = ent.Companies.FirstOrDefault(c => c.CompanyId == id);
                    if (dat != null)
                    {
                        dat.CompanyName = company.CompanyName;
                        dat.AuthorisedPerson = company.AuthorisedPerson;
                        dat.City = company.City;
                        dat.Country = company.Country;
                        dat.EmailId = company.EmailId;
                        dat.GSTNo = company.GSTNo;
                        dat.HandPhoneNo = company.HandPhoneNo;
                        dat.Pincode = company.Pincode;
                        dat.StateCode = company.StateCode;
                        dat.Street = company.Street;
                        dat.State = company.State;
                        dat.TaxNo = company.TaxNo;
                        dat.TelePhoneNo = company.TelePhoneNo;
                        dat.UintNo = company.UintNo;
                        dat.Website = company.Website;
                        ent.SaveChanges();
                        return Request.CreateResponse(HttpStatusCode.OK, dat);
                    }
                    else
                        return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Company with id = " + id.ToString() + " not found to update");
                }
            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
            }
        
    }
}
