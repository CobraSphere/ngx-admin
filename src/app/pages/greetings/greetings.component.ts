import { Component, OnInit } from '@angular/core';
import { DataService } from '../../data.service';

@Component({
  selector: 'ngx-greetings',
  templateUrl: './greetings.component.html',
  styleUrls: ['./greetings.component.scss']
})
export class GreetingsComponent implements OnInit {

  greetings = [];

  constructor(private dataService: DataService) { }

  ngOnInit(): void {
    this.dataService.sendGetRequest().subscribe((data: any[])=>{
      console.log(data);
      this.greetings = data;
    })  
  }

}
