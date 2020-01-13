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
using System.Data.SqlClient;
using System.Data;
using System.Configuration;
using CNMSWebAPI.Models;

namespace CNMSWebAPI.Controllers.Process
{
    public class ProjectDescriptionController : ApiController
    {
        HttpContext httpContext = HttpContext.Current;
        string message = "";
        int clientid = 0;
        Boolean status = true;
        public HttpResponseMessage Get()
        {

            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });

        }
        [HttpGet]
        public HttpResponseMessage Get(int id)
        {
            string authHeader = this.httpContext.Request.Headers["Authorization"];
            clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
            using (ConstructionDBEntities ent = new ConstructionDBEntities())
            {
                ent.Configuration.ProxyCreationEnabled = false;
                //clientid = 1;
                var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                if (dbt != null)
                {

                    using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id=" + dbt.DB_Username + ";Password=" + dbt.DB_Password + ";"))
                    //using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";Integrated Security = True;"))
                    {
                        DataTable dt1 = new DataTable();
                        connection.Open();
                        if (id != 0)
                        {
                            dt1 = new DataTable();
                            List<ProjectDescriptionModel> pd1 = new List<ProjectDescriptionModel>();
                            SqlDataAdapter da = new SqlDataAdapter("select * from ProjectDescription where ProjectId=" + id, connection);                            
                            da.Fill(dt1);

                            if(dt1.Rows.Count>0)
                            {
                                
                                List<ProjectDescription1> p1 = new List<ProjectDescription1>();
                                List<Foundation> f1 = new List<Foundation>();                                
                                List<Basement> b1 = new List<Basement>();
                                List<Podium> po1 = new List<Podium>();
                                List<LMezanine> m1 = new List<LMezanine>();
                                List<NameList> n1 = new List<NameList>();
                                List<List> l1 = new List<List>();
                                List<LowerRoof> lr1 = new List<LowerRoof>();
                                List<UpperRoof> ur1 = new List<UpperRoof>();
                                List<ExternalWork> e1 = new List<ExternalWork>();
                                List<MainItem> mi1 = new List<MainItem>();
                                List<Floor> fr1 = new List<Floor>();


                                ProjectDescriptionModel pd = new ProjectDescriptionModel();
                                pd.ProjectId = dt1.Rows[0]["ProjectId"].ToString();

                                ProjectDescription1 p = new ProjectDescription1();
                                

                                Foundation f = new Foundation();
                                if (dt1.Rows[0]["Foundation"].ToString() == "0")
                                {
                                    f.status = 0;
                                    f.qty = 0;
                                    f1.Add(f);
                                }
                                else
                                {
                                    f.status = 1;
                                    f.qty = Convert.ToInt32(dt1.Rows[0]["Foundation"].ToString());
                                    f1.Add(f);
                                }
                                //p.Foundation = f1;

                                Basement b = new Basement();
                                if (dt1.Rows[0]["Basement"].ToString() == "0")
                                {
                                    b.status = 0;
                                    b.qty = 0;
                                    b1.Add(b);
                                }
                                else
                                {
                                    b.status = 1;
                                    b.qty = Convert.ToInt32(dt1.Rows[0]["Basement"].ToString());
                                    b1.Add(b);
                                }
                                //p.Basement = b1;


                                Podium po = new Podium();
                                if (dt1.Rows[0]["Podium"].ToString() == "0")
                                {
                                    po.status = 0;
                                    po.qty = 0;
                                    po1.Add(po);
                                }
                                else
                                {
                                    po.status = 1;
                                    po.qty = Convert.ToInt32(dt1.Rows[0]["Podium"].ToString());
                                    po1.Add(po);
                                }
                                //p.Podium = po1;

                                LMezanine m = new LMezanine();
                                if (dt1.Rows[0]["Mezanine"].ToString() == "0")
                                {
                                    m.status = 0;
                                    m.qty = 0;
                                    m1.Add(m);
                                }
                                else
                                {
                                    m.status = 1;
                                    m.qty = Convert.ToInt32(dt1.Rows[0]["Mezanine"].ToString());
                                    m1.Add(m);
                                }
                                //p.Mezanine = m1;


                                //BlockDetails
                                dt1 = new DataTable();
                                da = new SqlDataAdapter("select * from BlockDetails where ProjectId=" + pd.ProjectId, connection);
                                da.Fill(dt1);
                                if (dt1.Rows.Count > 0)
                                {
                                    NameList n = new NameList();
                                    n.name = dt1.Rows[0]["BlockName"].ToString();
                                   

                                    for (int i = 0; i < dt1.Rows.Count; i++)
                                    {

                                        List l = new List();
                                        LowerRoof lr = new LowerRoof();
                                        UpperRoof ur = new UpperRoof();
                                        Floor fr = new Floor();


                                        l.name = dt1.Rows[i]["BlockName"].ToString();
                                        //l.qty = Convert.ToInt32(dt1.Rows[i]["BlockQty"].ToString());

                                        if (dt1.Rows[i]["BlockQty"].ToString() == "0")
                                        {

                                            fr.status = 0;
                                            fr.qty = 0;
                                            //  lr1.Add(lr);

                                        }
                                        else
                                        {

                                            fr.status = 1;
                                            fr.qty = Convert.ToInt32(dt1.Rows[i]["BlockQty"].ToString());

                                        }


                                        if (dt1.Rows[i]["LoweRoof"].ToString() == "0")
                                        {
                                            
                                            lr.status = 0;
                                            lr.qty = 0;
                                          //  lr1.Add(lr);
                                            
                                        }
                                        else
                                        {
                                         
                                            lr.status = 1;
                                            lr.qty = Convert.ToInt32(dt1.Rows[i]["LoweRoof"].ToString());
                                            
                                        }
                                        

                                        
                                        if (dt1.Rows[i]["UpperRoof"].ToString() == "0")
                                        {
                                            
                                            ur.status = 0;
                                            ur.qty = 0;
                                           // ur1.Add(ur);
                                            
                                        }
                                        else
                                        {
                                            
                                            ur.status = 1;
                                            ur.qty = Convert.ToInt32(dt1.Rows[i]["UpperRoof"].ToString());
                                            //ur1.Add(ur);
                                            
                                        }
                                        fr1.Add(fr);
                                        lr1.Add(lr);
                                        ur1.Add(ur);
                                        //l.Floor = fr1;
                                        //l.LowerRoof = lr1;
                                        //l.UpperRoof = ur1;
                                        l1.Add(l);




                                    }
                                    n.list = l1;
                                    n1.Add(n);
                                   
                                }

                                //ExternalWork
                                dt1 = new DataTable();
                                da = new SqlDataAdapter("select * from ExternalWorkDetails where ProjectId=" + pd.ProjectId, connection);
                                da.Fill(dt1);
                                if (dt1.Rows.Count > 0)
                                {
                                    for (int i = 0; i < dt1.Rows.Count; i++)
                                    {
                                        int eqty = Convert.ToInt32(dt1.Rows[i]["Qty"].ToString());
                                        ExternalWork e = new ExternalWork();
                                        e.externalName = dt1.Rows[i]["ExternalWork"].ToString(); 
                                        e.externalId= dt1.Rows[i]["ExDetId"].ToString();
                                        e.uom= dt1.Rows[i]["Units"].ToString();
                                        e.qty = eqty;
                                        e1.Add(e);
                                    }
                                }

                                // MainItems
                                dt1 = new DataTable();
                                da = new SqlDataAdapter("select * from MainItemMaster where ProjectId=" + pd.ProjectId, connection);
                                da.Fill(dt1);
                                if (dt1.Rows.Count > 0)
                                {
                                    for (int i = 0; i < dt1.Rows.Count; i++)
                                    {
                                        decimal eqty = Convert.ToDecimal(dt1.Rows[i]["Cost"].ToString());
                                        MainItem mi = new MainItem();
                                        mi.mainitem = dt1.Rows[i]["MainItemName"].ToString();                                        
                                        mi.cost = eqty;
                                        mi1.Add(mi);
                                    }
                                }
                                p1.Add(p);
                                pd.nameList = n1;
                                pd.ExternalWorks = e1;
                                pd.MainItems = mi1;                              
                                
                                //pd.ProjectDescription = p1;
                                pd1.Add(pd);

                            }

                            connection.Close();
                            return Request.CreateResponse(HttpStatusCode.OK, pd1);

                        }
                        else
                        {

                            SqlDataAdapter da = new SqlDataAdapter("select * from ExternalWorkMaster where Status=1", connection);
                            da.Fill(dt1);
                            connection.Close();
                            return Request.CreateResponse(HttpStatusCode.OK, dt1);


                        }
                    }
                }
                else
                {
                    message = "ProjectDescription Details not found";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                }
            }
        }
        [HttpPost]
        [Route("post")]
        public HttpResponseMessage Post([FromBody] ProjectDescriptionModel locat)
        {
            try
            {
                 
                if (locat.ProjectId == "0" || locat.ProjectId == "")
                {
                    status = false;
                    message = "Select Project";
                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                }
                    using (ConstructionDBEntities ent = new ConstructionDBEntities())
                    {
                        ent.Configuration.ProxyCreationEnabled = false;
                        var dbt1 = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                        if (dbt1 != null)
                        {
                            using (SqlConnection connection = new SqlConnection("Data Source=" + dbt1.Server_Name + ";Initial Catalog=" + dbt1.DB_Name + ";User Id=" + dbt1.DB_Username + ";Password=" + dbt1.DB_Password + ";"))
                            //using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";Integrated Security = True;"))
                            {
                                DataTable dt1 = new DataTable();
                                connection.Open();
                                SqlDataAdapter da = new SqlDataAdapter("select * from ProjectDescription where PDId=" + locat.ProjectId, connection);
                                da.Fill(dt1);

                                if (dt1.Rows.Count > 0)
                                {
                                    status = false;
                                    message = "ProjectDescription already exists";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }
                            }
                        }

                        int Basement = 0;
                        int Foundation = 0;
                        int Podium = 0;
                        int Mezanine = 0;


                        ////foreach (var Pitem in locat.ProjectDescription)
                        ////{
                        ////    foreach (var Fitem in Pitem.Foundation)
                        ////    {
                        //if (Fitem.status == 1 && Fitem.qty != 0)
                        //    Foundation = Fitem.qty;
                        //else if (Fitem.status == 0)
                        //{


                        //}
                        //else
                        //{

                        //    status = false;
                        //    message = "Enter Foundation";
                        //    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        //}
                        //}

                        if (locat.ProjectDescription.Foundation.status == 1 && locat.ProjectDescription.Foundation.qty != 0)
                            Foundation = locat.ProjectDescription.Foundation.qty;
                        else if (locat.ProjectDescription.Foundation.status == 0)
                        {


                        }
                        else
                        {
                            if (locat.ProjectDescription.Foundation.qty == 0)
                            {
                                status = false;
                                message = "Enter Foundation";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });

                            }
                            if (locat.ProjectDescription.Foundation.FoundationDes.Count > 0)
                            {
                                foreach (var citm in locat.ProjectDescription.Foundation.FoundationDes)
                                {
                                    if (citm.name == "")
                                    {
                                        status = false;
                                        message = "Enter Foundation Ref_Name";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                }
                            }
                            else
                            {
                                status = false;
                                message = "Enter Foundation Ref_Name";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }

                        }

                        //foreach (var Fitem in Pitem.Basement)
                        //{
                        //    if (Fitem.status == 1 && Fitem.qty != 0)
                        //        Basement = Fitem.qty;
                        //    else if (Fitem.status == 0)
                        //    {


                        //    }
                        //    else
                        //    {

                        //        status = false;
                        //        message = "Enter Basement";
                        //        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        //    }
                        //}
                        if (locat.ProjectDescription.Basement.status == 1 && locat.ProjectDescription.Basement.qty != 0)
                            Basement = locat.ProjectDescription.Basement.qty;
                        else if (locat.ProjectDescription.Basement.status == 0)
                        {


                        }
                        else
                        {
                            if (locat.ProjectDescription.Basement.qty == 0)
                            {
                                status = false;
                                message = "Enter Basement";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            if (locat.ProjectDescription.Basement.FoundationDes.Count > 0)
                            {
                                foreach (var citm in locat.ProjectDescription.Basement.FoundationDes)
                                {
                                    if (citm.name == "")
                                    {
                                        status = false;
                                        message = "Enter Basement Ref_Name";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                }
                            }
                            else
                            {
                                status = false;
                                message = "Enter Basement Ref_Name";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }


                        }
                        //foreach (var Fitem in Pitem.Podium)
                        //    {
                        //        if (Fitem.status == 1 && Fitem.qty != 0)
                        //            Podium = Fitem.qty;
                        //        else if (Fitem.status == 0)
                        //        {


                        //        }
                        //        else
                        //        {
                        //            status = false;
                        //            message = "Enter Podium";
                        //            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        //        }
                        //    }
                        if (locat.ProjectDescription.Podium.status == 1 && locat.ProjectDescription.Podium.qty != 0)
                            Podium = locat.ProjectDescription.Podium.qty;
                        else if (locat.ProjectDescription.Podium.status == 0)
                        {


                        }
                        else
                        {
                            if (locat.ProjectDescription.Podium.qty == 0)
                            {
                                status = false;
                                message = "Enter Podium";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            if (locat.ProjectDescription.Podium.FoundationDes.Count > 0)
                            {
                                foreach (var citm in locat.ProjectDescription.Podium.FoundationDes)
                                {
                                    if (citm.name == "")
                                    {
                                        status = false;
                                        message = "Enter Podium Ref_Name";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                }
                            }
                            else
                            {
                                status = false;
                                message = "Enter Podium Ref_Name";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                        }
                        //foreach (var Fitem in Pitem.Mezanine)
                        //    {
                        //        if (Fitem.status == 1 && Fitem.qty != 0)
                        //            Mezanine = Fitem.qty;
                        //        else if (Fitem.status == 0)
                        //        {


                        //        }
                        //        else
                        //        {

                        //            status = false;
                        //            message = "Enter Mezanine";
                        //            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                        //        }
                        //    }
                        //}
                        if (locat.ProjectDescription.Mezanine.status == 1 && locat.ProjectDescription.Mezanine.qty != 0)
                            Mezanine = locat.ProjectDescription.Mezanine.qty;
                        else if (locat.ProjectDescription.Mezanine.status == 0)
                        {


                        }
                        else
                        {
                            if (locat.ProjectDescription.Mezanine.qty == 0)
                            {
                                status = false;
                                message = "Enter Mezanine";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                            if (locat.ProjectDescription.Mezanine.FoundationDes.Count > 0)
                            {
                                foreach (var citm in locat.ProjectDescription.Mezanine.FoundationDes)
                                {
                                    if (citm.name == "")
                                    {
                                        status = false;
                                        message = "Enter Mezanine Ref_Name";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                }
                            }
                            else
                            {
                                status = false;
                                message = "Enter Mezanine Ref_Name";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                            }
                        }
                        if (locat.nameList.Count > 0)
                        {
                            foreach (var nitem in locat.nameList)
                            {
                                if (nitem.name == "")
                                {
                                    status = false;
                                    message = "Enter " + nitem.name;
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }
                                foreach (var n1item in nitem.list)
                                {
                                    if (n1item.Floor.status == 1 && n1item.Floor.qty != 0)
                                    {
                                    }
                                    else if (n1item.Floor.status == 0)
                                    {
                                    }
                                    else
                                    {
                                        if (n1item.Floor.qty == 0)
                                        {
                                            status = false;
                                            message = "Enter Floor Qty of " + nitem.name + " - " + n1item.name;
                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                        }
                                        if (n1item.Floor.FoundationDes.Count > 0)
                                        {
                                            foreach (var citm in n1item.Floor.FoundationDes)
                                            {
                                                if (citm.name == "")
                                                {
                                                    status = false;
                                                    message = "Enter Floor Ref_Name of " + nitem.name + " - " + n1item.name;
                                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                                }
                                            }
                                        }
                                        else
                                        {
                                            status = false;
                                            message = "Enter Floor Ref_Name of " + nitem.name + " - " + n1item.name;
                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                        }
                                    }

                                    if (n1item.LowerRoof.status == 1 && n1item.LowerRoof.qty != 0)
                                    {
                                    }
                                    else if (n1item.LowerRoof.status == 0)
                                    {
                                    }
                                    else
                                    {
                                        if (n1item.LowerRoof.qty == 0)
                                        {
                                            status = false;
                                            message = "Enter Lower Roof Qty of " + nitem.name + " - " + n1item.name;
                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                        }
                                        if (n1item.LowerRoof.FoundationDes.Count > 0)
                                        {
                                            foreach (var citm in n1item.LowerRoof.FoundationDes)
                                            {
                                                if (citm.name == "")
                                                {
                                                    status = false;
                                                    message = "Enter Lower Roof Ref_Name of " + nitem.name + " - " + n1item.name;
                                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                                }
                                            }
                                        }
                                        else
                                        {
                                            status = false;
                                            message = "Enter Lower Roof Ref_Name of " + nitem.name + " - " + n1item.name;
                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                        }
                                    }
                                    if (n1item.UpperRoof.status == 1 && n1item.UpperRoof.qty != 0)
                                    {
                                    }
                                    else if (n1item.UpperRoof.status == 0)
                                    {
                                    }
                                    else
                                    {
                                        if (n1item.UpperRoof.qty == 0)
                                        {
                                            status = false;
                                            message = "Enter Upper Roof Qty of  " + nitem.name + " - " + n1item.name;
                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });

                                        }
                                        if (n1item.UpperRoof.FoundationDes.Count > 0)
                                        {
                                            foreach (var citm in n1item.UpperRoof.FoundationDes)
                                            {
                                                if (citm.name == "")
                                                {
                                                    status = false;
                                                    message = "Enter Upper Roof Ref_Name of " + nitem.name + " - " + n1item.name;
                                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                                }
                                            }
                                        }
                                        else
                                        {
                                            status = false;
                                            message = "Enter Upper Roof Ref_Name of " + nitem.name + " - " + n1item.name;
                                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                        }
                                    }
                                }
                                //    foreach (var n1item in nitem.list)
                                //    {
                                //    foreach (var item in n1item.Floor)
                                //    {
                                //        if (item.status == 1 && item.qty != 0)
                                //        {
                                //        }
                                //        else if (item.status == 0)
                                //        {
                                //        }
                                //        else
                                //        {

                                //            status = false;
                                //            message = "Enter Floor Qty of " + nitem.name + " - " + n1item.name;
                                //            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                //        }
                                //    }
                                //    foreach (var item in n1item.LowerRoof)
                                //    {
                                //        if (item.status == 1 && item.qty != 0)
                                //        {
                                //        }
                                //        else if (item.status == 0)
                                //        {
                                //        }
                                //        else
                                //        {

                                //            status = false;
                                //            message = "Enter Lower Roof Qty of " + nitem.name + " - " + n1item.name;
                                //            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                //        }
                                //    }
                                //    foreach (var item in n1item.UpperRoof)
                                //    {
                                //        if (item.status == 1 && item.qty != 0)
                                //        {
                                //        }
                                //        else if (item.status == 0)
                                //        {
                                //        }
                                //        else
                                //        {

                                //            status = false;
                                //            message = "Enter Upper Roof Qty of  " + nitem.name + " - " + n1item.name;
                                //            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                //        }
                                //    }

                                //}
                            }
                        }
                        if (locat.ExternalWorks.Count > 0)
                        {
                            foreach (var item in locat.ExternalWorks)
                            {
                            if (item.externalName == "")
                                //if (item.externalId == "" || item.externalId == "0")
                                {
                                    status = false;
                                    message = "Enter External Work Name";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }
                                else
                                {
                                    if (item.qty == 0)
                                    {
                                        status = false;
                                        message = "Enter External Work Items/Qty";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                }

                                if (item.uom == "")
                                {
                                    status = false;
                                    message = "Select External Work Units";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }
                            }
                        }
                    if (locat.MainItems.Count > 0)
                    {
                        foreach (var item in locat.MainItems)
                        {
                            if (item.mainitem == "")
                            {
                                status = false;
                                message = "Enter MainItems";
                                return Request.CreateResponse(HttpStatusCode.OK, new { message, status });

                            }
                            else
                            { }

                        }
                    }
                    else
                    {
                        status = false;
                        message = "Enter MainItems";
                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                    }

                        string authHeader = this.httpContext.Request.Headers["Authorization"];
                        clientid = Convert.ToInt32(Models.JwtAuthentication.GetTokenClientId(authHeader));
                        int userid = Convert.ToInt32(Models.JwtAuthentication.GetTokenUserId(authHeader));



                        var dbt = (from a in ent.DatabaseDetails where a.ClientId == clientid select a).FirstOrDefault();
                        if (dbt != null)
                        {

                            using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";User Id=" + dbt.DB_Username + ";Password=" + dbt.DB_Password + ";"))
                            //using (SqlConnection connection = new SqlConnection("Data Source=" + dbt.Server_Name + ";Initial Catalog=" + dbt.DB_Name + ";Integrated Security = True;"))
                            {
                                DataTable dt1 = new DataTable();
                                connection.Open();
                                SqlDataAdapter da = new SqlDataAdapter("select * from ProjectDescription where PDId=" + locat.ProjectId, connection);
                                da.Fill(dt1);

                                if (dt1.Rows.Count > 0)
                                {
                                    status = false;
                                    message = "ProjectDescription already exists";
                                    return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                }
                                else
                                {
                                    da = new SqlDataAdapter("select * from ProjectDescription pd join ProjectMaster p on p.ProjectId=pd.ProjectId where ClientId=" + clientid, connection);
                                    da.Fill(dt1);
                                    if (dt1.Rows.Count > 0)
                                    {
                                        status = false;
                                        message = "User not valid to create more then one projects ProjectDescription";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                    else
                                    {




                                        SqlDataAdapter adapter = new SqlDataAdapter();
                                        string sql = "insert into ProjectDescription (ProjectId,Foundation,Basement,Podium,Mezanine,UserId) values(" + locat.ProjectId + "," + Foundation + "," + Basement + "," + Podium + "," + Mezanine + "," + userid + ")";
                                        adapter.InsertCommand = new SqlCommand(sql, connection);
                                        adapter.InsertCommand.ExecuteNonQuery();

                                        DataTable ndt1 = new DataTable();
                                        da = new SqlDataAdapter("select max(PDId) from ProjectDescription pd where pd.ProjectId=" + locat.ProjectId, connection);
                                        da.Fill(ndt1);
                                        if (ndt1.Rows.Count > 0)
                                        {
                                            long pdid = Convert.ToInt64(ndt1.Rows[0][0].ToString());
                                            if (Foundation != 0)
                                            {
                                                foreach (var citm in locat.ProjectDescription.Foundation.FoundationDes)
                                                {
                                                    string nam = citm.name;
                                                    adapter = new SqlDataAdapter();
                                                    sql = "insert into ProjectDescriptionDetails values(" + pdid + "," + locat.ProjectId + ",'" + nam + "','FO')";
                                                    adapter.InsertCommand = new SqlCommand(sql, connection);
                                                    adapter.InsertCommand.ExecuteNonQuery();
                                                }
                                            }

                                            if (Basement != 0)
                                            {
                                                foreach (var citm in locat.ProjectDescription.Basement.FoundationDes)
                                                {
                                                    string nam = citm.name;
                                                    adapter = new SqlDataAdapter();
                                                    sql = "insert into ProjectDescriptionDetails values(" + pdid + "," + locat.ProjectId + ",'" + nam + "','BA')";
                                                    adapter.InsertCommand = new SqlCommand(sql, connection);
                                                    adapter.InsertCommand.ExecuteNonQuery();
                                                }
                                            }

                                            if (Podium != 0)
                                            {
                                                foreach (var citm in locat.ProjectDescription.Podium.FoundationDes)
                                                {
                                                    string nam = citm.name;
                                                    adapter = new SqlDataAdapter();
                                                    sql = "insert into ProjectDescriptionDetails values(" + pdid + "," + locat.ProjectId + ",'" + nam + "','PO')";
                                                    adapter.InsertCommand = new SqlCommand(sql, connection);
                                                    adapter.InsertCommand.ExecuteNonQuery();
                                                }
                                            }

                                            if (Mezanine != 0)
                                            {
                                                foreach (var citm in locat.ProjectDescription.Mezanine.FoundationDes)
                                                {
                                                    string nam = citm.name;
                                                    adapter = new SqlDataAdapter();
                                                    sql = "insert into ProjectDescriptionDetails values(" + pdid + "," + locat.ProjectId + ",'" + nam + "','ME')";
                                                    adapter.InsertCommand = new SqlCommand(sql, connection);
                                                    adapter.InsertCommand.ExecuteNonQuery();
                                                }
                                            }

                                        }

                                        if (locat.nameList.Count > 0)
                                        {
                                            foreach (var nitem in locat.nameList)
                                            {
                                                foreach (var n1item in nitem.list)
                                                {
                                                    string name = nitem.name + "-" + n1item.name;
                                                    int qty = 0;
                                                    int LowerRoofq = 0;
                                                    int UpperRoofq = 0;
                                                    qty = n1item.Floor.qty;
                                                    LowerRoofq = n1item.LowerRoof.qty;
                                                    UpperRoofq = n1item.UpperRoof.qty;
                                                    //foreach (var item in n1item.Floor)
                                                    //{
                                                    //    qty = item.qty;
                                                    //}
                                                    //foreach (var item in n1item.LowerRoof)
                                                    //{
                                                    //    LowerRoofq = item.qty;
                                                    //}
                                                    //foreach (var item in n1item.UpperRoof)
                                                    //{
                                                    //    UpperRoofq = item.qty;
                                                    //}
                                                    if(qty!=0)
                                                {
                                                    adapter = new SqlDataAdapter();
                                                    sql = "insert into BlockDetails values(" + locat.ProjectId + ",'" + name + "'," + LowerRoofq + "," + UpperRoofq + "," + qty + ")";
                                                    adapter.InsertCommand = new SqlCommand(sql, connection);
                                                    adapter.InsertCommand.ExecuteNonQuery();



                                                    DataTable ndt2 = new DataTable();
                                                    da = new SqlDataAdapter("select max(BlockId) from BlockDetails", connection);
                                                    da.Fill(ndt2);
                                                    if (ndt2.Rows.Count > 0)
                                                    {
                                                        long pdid1 = Convert.ToInt64(ndt2.Rows[0][0].ToString());
                                                        if (qty != 0)
                                                        {
                                                            foreach (var citm in n1item.Floor.FoundationDes)
                                                            {
                                                                string nam = citm.name;
                                                                adapter = new SqlDataAdapter();
                                                                sql = "insert into ProjectDescriptionDetails values(" + pdid1 + "," + locat.ProjectId + ",'" + nam + "','FL')";
                                                                adapter.InsertCommand = new SqlCommand(sql, connection);
                                                                adapter.InsertCommand.ExecuteNonQuery();
                                                            }
                                                        }
                                                        if (LowerRoofq != 0)
                                                        {
                                                            foreach (var citm in n1item.LowerRoof.FoundationDes)
                                                            {
                                                                string nam = citm.name;
                                                                adapter = new SqlDataAdapter();
                                                                sql = "insert into ProjectDescriptionDetails values(" + pdid1 + "," + locat.ProjectId + ",'" + nam + "','LR')";
                                                                adapter.InsertCommand = new SqlCommand(sql, connection);
                                                                adapter.InsertCommand.ExecuteNonQuery();
                                                            }
                                                        }
                                                        if (UpperRoofq != 0)
                                                        {
                                                            foreach (var citm in n1item.UpperRoof.FoundationDes)
                                                            {
                                                                string nam = citm.name;
                                                                adapter = new SqlDataAdapter();
                                                                sql = "insert into ProjectDescriptionDetails values(" + pdid1 + "," + locat.ProjectId + ",'" + nam + "','UR')";
                                                                adapter.InsertCommand = new SqlCommand(sql, connection);
                                                                adapter.InsertCommand.ExecuteNonQuery();
                                                            }
                                                        }
                                                    }
                                                }
                                                }
                                            }
                                        }
                                        if (locat.ExternalWorks.Count > 0)
                                        {
                                            foreach (var item in locat.ExternalWorks)
                                            {
                                                adapter = new SqlDataAdapter();
                                                sql = "insert into ExternalWorkDetails values(" + locat.ProjectId + ",'" + item.externalName + "','" + item.uom + "'," + item.qty + ")";
                                                adapter.InsertCommand = new SqlCommand(sql, connection);
                                                adapter.InsertCommand.ExecuteNonQuery();
                                            }
                                        }
                                        if (locat.MainItems.Count > 0)
                                        {
                                            foreach (var item in locat.MainItems)
                                            {
                                                adapter = new SqlDataAdapter();
                                                sql = "insert into MainItemMaster values(" + locat.ProjectId + ",'" + item.mainitem + "'," + item.cost + ")";
                                                adapter.InsertCommand = new SqlCommand(sql, connection);
                                                adapter.InsertCommand.ExecuteNonQuery();
                                            }
                                        }
                                        connection.Close();
                                        message = "Saved Successfully";
                                        return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
                                    }
                                }
                            }
                        }
                        else
                        {
                            message = "Project Description Details not found";
                            return Request.CreateResponse(HttpStatusCode.OK, new { message, status });
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
