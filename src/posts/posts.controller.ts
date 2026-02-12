import {
    Controller,
    Get,
    Post,
    Body,
    Patch,
    Param,
    Delete,
    UseGuards,
    Request,
} from '@nestjs/common';
import { PostsService } from './posts.service';
import { CreatePostDto } from './dto/create-post.dto';
import { UpdatePostDto } from './dto/update-post.dto';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';
import { RequestWithUser } from '../common/interfaces/request-with-user.interface';

@Controller('posts')
export class PostsController {
    constructor(private readonly postsService: PostsService) { }

    @UseGuards(JwtAuthGuard)
    @Post()
    create(
        @Body() createPostDto: CreatePostDto,
        // @ts-expect-error - RequestWithUser used for type safety, decorator metadata warning can be ignored
        @Request() req: RequestWithUser,
    ) {
        return this.postsService.create(createPostDto, req.user);
    }

    @Get()
    findAll() {
        return this.postsService.findAll();
    }

    // Specific routes must come BEFORE generic :id route
    @Get('author/:authorId')
    findByAuthor(@Param('authorId') authorId: string) {
        return this.postsService.findByAuthor(authorId);
    }

    @Get(':id')
    findOne(@Param('id') id: string) {
        return this.postsService.findOne(id);
    }

    @UseGuards(JwtAuthGuard)
    @Patch(':id')
    update(
        @Param('id') id: string,
        @Body() updatePostDto: UpdatePostDto,
        // @ts-expect-error - RequestWithUser used for type safety, decorator metadata warning can be ignored
        @Request() req: RequestWithUser,
    ) {
        return this.postsService.update(id, updatePostDto, req.user.id);
    }

    @UseGuards(JwtAuthGuard)
    @Delete(':id')
    // @ts-expect-error - RequestWithUser used for type safety, decorator metadata warning can be ignored
    remove(@Param('id') id: string, @Request() req: RequestWithUser) {
        return this.postsService.remove(id, req.user.id);
    }
}
