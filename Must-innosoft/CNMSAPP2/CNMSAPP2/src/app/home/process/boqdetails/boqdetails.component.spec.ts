import { async, ComponentFixture, TestBed } from '@angular/core/testing';
import { BoqdetailsComponent } from './boqdetails.component';

describe('BoqdetailsComponent', () => {
  let component: BoqdetailsComponent;
  let fixture: ComponentFixture<BoqdetailsComponent>;

  beforeEach(
    async(() => {
      TestBed.configureTestingModule({
        declarations: [BoqdetailsComponent]
      }).compileComponents();
    })
  );

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqdetailsComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
