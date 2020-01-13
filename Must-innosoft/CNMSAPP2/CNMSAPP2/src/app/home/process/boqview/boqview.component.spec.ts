import { async, ComponentFixture, TestBed } from '@angular/core/testing';

import { BoqviewComponent } from './boqview.component';

describe('BoqviewComponent', () => {
  let component: BoqviewComponent;
  let fixture: ComponentFixture<BoqviewComponent>;

  beforeEach(async(() => {
    TestBed.configureTestingModule({
      declarations: [ BoqviewComponent ]
    })
    .compileComponents();
  }));

  beforeEach(() => {
    fixture = TestBed.createComponent(BoqviewComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
