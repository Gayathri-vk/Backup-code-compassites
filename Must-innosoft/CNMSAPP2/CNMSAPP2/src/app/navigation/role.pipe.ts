import { Pipe, PipeTransform } from '@angular/core';

@Pipe({
  name: 'rolefilter'
})

export class RolePipe implements PipeTransform {
  transform(value: any, ...args: any[]): any {
    const r = +args[0];
    if (r) {
      return value.filter((main, index) => {
        if (main.role.indexOf(r) !== -1) {
          return true;
        }
        return false;
      });
    }
    return [];
  }
}
