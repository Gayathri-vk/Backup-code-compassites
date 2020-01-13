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
    public class CompanyController : ApiController
    {
        string message = "";
        Boolean status = true;
        public IEnumerable<Company> Get()
        {

            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
        
                
                return ent.Companies.ToList();
            }
        }



        public HttpResponseMessage Get(int id)
        {
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                var dat = ent.Companies.FirstOrDefault(c => c.CompanyId == id);
                if (dat != null)
                {
                    return Request.CreateResponse(HttpStatusCode.OK, dat);

                }
                else
                {
                    message = "Company with id = " + id.ToString() + " not found";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    //return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Company with id = " + id.ToString() + " not found");
                }
            }
        }
        public HttpResponseMessage Post([FromBody] Company company)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    var dat = ent.Companies.FirstOrDefault(c => c.CompanyId == 1);
                    if (dat == null)
                    {
                        ent.Companies.Add(company);
                        ent.SaveChanges();
                        message = "Saved Successfully";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    }
                    else
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
                        message = "Updated Successfully";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    }
                    //var message = Request.CreateResponse(HttpStatusCode.Created, company);
                    //message.Headers.Location = new Uri(Request.RequestUri + "/" + company.CompanyId.ToString());
                    //return message;
                }
            }
            catch (Exception ex)
            {
                return Request.CreateErrorResponse(HttpStatusCode.BadRequest, ex);
            }
        }

        public HttpResponseMessage Put(int id, [FromBody] Company company)
        {
            try
            {
                using (ConstructionDBEntities ent = new ConstructionDBEntities())
                {
                    ent.Configuration.ProxyCreationEnabled = false;
                    var dat = ent.Companies.FirstOrDefault(c => c.CompanyId == company.CompanyId);
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
                        message = "Updated Successfully";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        //return Request.CreateResponse(HttpStatusCode.OK, dat);
                    }
                    else
                    {
                        //message = "Company with id = " + company.CompanyId.ToString() + " not found";
                        //status = false;
                        //return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        return Request.CreateErrorResponse(HttpStatusCode.NotFound, "Company with id = " + company.CompanyId.ToString() + " not found to update");
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
